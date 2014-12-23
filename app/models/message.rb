class Message < ActiveRecord::Base
  include Inheritable::Sti
  include Taggable
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Searchable
  include Parsable
  parsers << 'Messages::Parser'

  act_as_sti(
    chat: 'ChatMessage',
    github: 'GithubMessage'
  )

  belongs_to :room, inverse_of: :messages
  belongs_to :parent, class_name: 'Message'
  belongs_to :author, class_name: 'User', inverse_of: :messages
  has_many :children, foreign_key: 'parent_id', class_name: 'Message'

  has_attached_file :attachment,
    default_url: "",
    styles: { medium: '300x300' }

  validates :room_id, presence: true
  do_not_validate_attachment_file_type :attachment

  before_update :mark_as_edited
  after_save :update_body_from_attachment
  after_update :flush_parent_cache
  after_commit :flush_parent_cache

  # Elastic search settings

  tire.index_name model_name.name.underscore.pluralize

  settings analysis: {
    filter: {
      ngram_filter: {
        type: "nGram",
        min_gram: 1,
        max_gram: 15
      }
    },
    analyzer: {
      index_ngram_analyzer: {
        tokenizer: "standard",
        filter: ['standard', 'lowercase', "stop", "ngram_filter"],
        type: "custom"
      },
      search_ngram_analyzer: {
        tokenizer: "standard",
        filter: ['standard', 'lowercase', "stop"],
        type: "custom"
      }
    }
  }

  mapping do
    indexes :id,
      type: :long,
      index: :not_analyzed
    indexes :room_id,
      type: :long
    indexes :body,
      search_analyzer: 'search_ngram_analyzer',
      index_analyzer: 'index_ngram_analyzer',
      boost: 100
    indexes :created_at,
      type: :date,
      index: :not_analyzed
    indexes :stringified_tag_ids,
      type: :string,
      analyzer: :keyword
  end

  # Methods

  def attachment_url
    attachment.url
  end

  def attachment_thumb_url
    attachment.url(:medium)
  end

  def has_children
    Rails.cache.fetch("#{cache_key}/has_children") { self.children.count > 0 }
  end

  alias_method :parent?, :has_children
  alias_method :has_children?, :has_children

  def self.cached_find(id, updated_at)
    cache_key = [model_name.cache_key, id, updated_at.to_i].join("/")

    Rails.cache.fetch(cache_key) { includes(:author).find(id) }
  end

  def self.cached_ids_with_updated_at(query)
    conditions = query.where_values_hash.with_indifferent_access
    cache_key_base = ["#{model_name.cache_key}_ids"]
    cache_key_from_conditions = {
      room: conditions.fetch(:room_id, '_none_'),
      type: conditions.fetch(:type, 'all')
    }.flatten
    cache_key = cache_key_base.concat(cache_key_from_conditions).join '/'

    Rails.cache.fetch(cache_key) { query.pluck(:id, :updated_at) }
  end

  def self.cached(conditions = {}, order_dir = :desc, page = 1, per_page = 35)

    query = self

    # process pagination data
    page ||= 1
    per_page ||= 35
    # start_idx = (page.to_i - 1) * per_page.to_i #uncomment this if cache is enabled
    # start_idx = 0 if start_idx < 0 #uncomment this if cache is enabled

    # apply filters
    conditions.each { |condition, value| query = query.where(condition => value) }

    # eager load associations
    query = query.includes(:author)

    # paginate
    query = query.page(page).per(per_page)

    # order
    order_dir ||= :desc
    ordering = { :created_at => order_dir }
    query = query.order(ordering)

    return query

    # [NEED FIX] uncomment this block if cache is enabled
    # load ids and updated_at pairs
    # message_ids_with_updated_at = cached_ids_with_updated_at(query)

    # paginate results

    # message_ids_with_updated_at = Kaminari
    #   .paginate_array(message_ids_with_updated_at)
    #   .page(page).per(per_page)

    # return [] if message_ids_with_updated_at.empty?

    # # find messages
    # message_ids_with_updated_at.map do |id_and_updated_at|
    #   id, updated_at = *id_and_updated_at
    #   cached_find(id, updated_at)
    # end
  end

  def self.context(id, room_id)
    top = Message.where(:room_id => room_id)
                 .where(Message.arel_table[:id].lteq(id))
                 .order(:created_at => :desc)
                 .limit(20).reverse()

    down = Message.where(:room_id => room_id)
                  .where(Message.arel_table[:id].gt(id))
                  .order(:created_at => :asc)
                  .limit(20)
    top + down
  end

  def self.search(query, room_id, page = 1, per_page = 35)

    return [] if query.blank?

    tag_ids = Messages::SearchQueryParser.new(query, room_id)
      .extract_tag_ids(stringify: true)

    escaped_query = tag_ids.present? ? "*" : escape_for_search(query)

    tire.search(load: true, type: nil, page: page, per_page: per_page) do
      query do
        filtered do
          query  { string escaped_query, default_field: :body }
          filter :term, room_id: room_id
          filter :terms, stringified_tag_ids: tag_ids, execution: 'and' if tag_ids.present?
        end
      end
      sort { by :created_at, 'desc' }
    end
  end

  def to_indexed_json
    to_json({
      only: [:id, :body, :author_id, :room_id, :type, :created_at, :updated_at],
      methods: [:stringified_tag_ids]
    })
  end

  private

  def flush_parent_cache
    parent.try(:touch)
  end

  def mark_as_edited
    self.edited_at = Time.current if body_changed?
  end

  def update_body_from_attachment
    if attachment.present? && attachment_updated_at_changed?
      update_column(:body, attachment.url)
    end
  end

end
