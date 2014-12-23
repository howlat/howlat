module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug
    before_save :generate_slug

    private

    def generate_slug
      self.slug = ::Converters::NameToSlug.new.convert(name) if name_changed?
      true
    end
  end

end
