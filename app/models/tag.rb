class Tag < ActiveRecord::Base
  include Inheritable::Sti

  scope :by_name, ->() { order(name: :asc) }

  has_many :taggings, dependent: :destroy, inverse_of: :tag
  has_many :messages, through: :taggings

  validates :name, uniqueness: true, presence: true

  act_as_sti({
    hash_tag: 'Tags::HashTag',
    user_tag: 'Tags::UserTag',
    github_tag: 'Tags::GithubTag'
  })

  PREFIX = ''

  def prefix
    self.class::PREFIX
  end

  def name=(new_name)
    name_value = new_name.blank? ? '' : apply_prefix(new_name)
    write_attribute(:name, name_value)
  end

  def to_label
    "#{self.class::PREFIX}#{name}"
  end

  private

  def apply_prefix(tag_name)
    tag_name.to_s.start_with?(prefix) ? tag_name : tag_name.to_s.prepend(prefix)
  end

  def self.type_value_from_name(tag_name)
    return self if subclasses.empty?
    default = Tags::HashTag
    candidate = (subclasses - [default]).select do |subclass|
      tag_name.start_with? subclass::PREFIX
    end.first
    sti_map.key (candidate or default).name
  end

  def self.subclass_value_from_attributes(attrs)
    tag_name = attrs.with_indifferent_access[:name]
    type_value_from_name(tag_name)
  end

end
