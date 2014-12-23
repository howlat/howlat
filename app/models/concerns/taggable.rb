require 'active_support/concern'

module Taggable
  extend ActiveSupport::Concern

  included do

    has_many :taggings, inverse_of: :message, validate: false
    has_many :tags, -> { distinct }, through: :taggings, validate: false do

      def add(*tag_names)
        transaction do
          tag_names.map(&:downcase).each do |tag_name|
            add_tag(tag_name)
          end
        end
        self
      end

      def remove(*tag_names)
        destroy(Tag.where(name: tag_names))
      end

      private

      def add_tag(tag_name)
        new_tag = Tag.unscoped.where(name: tag_name).first
        new_tag ||= Tag.unscoped.create(name: tag_name)

        self << new_tag
      rescue ActiveRecord::RecordInvalid
        self
      end

    end

    after_commit :cache_tag_list

    def tag_list
      persisted? ? tags.by_name.pluck(:name) : tags.map(&:name)
    end

    def stringified_tag_ids
      (persisted? ? taggings.pluck(:tag_id) : taggings.map(&:tag_id)).map(&:to_s)
    end

    def cached_tag_list
      Rails.cache.fetch(cache_tag_list_key) { tag_list }
    end

    def cache_tag_list
      Rails.cache.write cache_tag_list_key, tag_list
    end

    def cache_tag_list_key
      "#{cache_key}/tag_list"
    end

  end

  module ClassMethods
    def tagged_with(tag_names)
      group_by = [
        connection.quote_table_name(table_name),
        connection.quote_column_name('id')
      ].join(".")

      joins(:tags)
      .where(tags: { name: tag_names })
      .group(group_by)
      .having("COUNT(#{group_by}) = ?", tag_names.count)
    end
  end
end
