module Searchable
  extend ActiveSupport::Concern

  SPECIAL_CHARACTERS_REGEXP = /([\+\-\&\|\!\(\)\{\}\[\]\^\"\~\*\?\:\\])/

  module ClassMethods

    private

    def escape_for_search(string)
      string.gsub(SPECIAL_CHARACTERS_REGEXP) { |char| "\\#{char}" }
    end

  end
end

