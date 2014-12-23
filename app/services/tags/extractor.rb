module Tags
  class Extractor

    def call(message)
      tags = []
      tags.concat extract_mentions(message)
      tags.concat extract_hashtags(message)

      tags.compact
    end

    private

    def extract_mentions(message)
      tag_class = Tags::UserTag
      tag_names = extract(message.body, tag_class)

      return [] if tag_names.empty?

      tags, usernames, everyone_detected = [], [], false
      tag_names.each do |tagname|
        if Tags::UserTag::EVERYONE_KEYS.include? tagname
          everyone_detected = true
        else
          usernames << tagname
        end
      end
      tags = message.room.members.where(name: usernames).pluck(:id).map do |id|
        "#{tag_class::PREFIX}:#{id}"
      end unless usernames.empty?
      tags << "#{tag_class::PREFIX}:everyone" if everyone_detected

      tags
    end

    def extract_hashtags(message)
      extract(message.body, Tags::HashTag)
    end

    def extract(text, tag_class)
      text.to_s.scan(tag_class::REGEXP).flatten.uniq
    end

  end
end
