require 'i18n'

module Converters
  class NameToSlug

    def convert(name)
      slug = I18n.transliterate(name.to_s.strip).downcase

      #blow away apostrophes
      slug.gsub!(/['`]/, "")

      # @ --> at, and & --> and, % --> percent
      slug.gsub!(/\s*\.\s*/, "-dot-")
      slug.gsub!(/\s*@\s*/, "-at-")
      slug.gsub!(/\s*&\s*/, "-and-")
      slug.gsub!(/\s*%\s*/, "-percent-")

      #replace all non alphanumeric, underscores or periods with hyphens
      slug.gsub!(/\s*[^A-Za-z0-9\.\_]\s*/, '-')

      #convert double hyphens to single
      slug.gsub!(/-+/,"-")

      #strip off leading/trailing hyphens
      slug.gsub!(/\A[-\.]+|[-\.]+\z/,"")

      slug
    end
  end
end
