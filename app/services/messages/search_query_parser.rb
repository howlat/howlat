module Messages
  class SearchQueryParser

    def initialize(query, room_id)
      @query = query
      @room_id = room_id
    end

    def extract_tags
      message = Message.new(body: @query, room_id: @room_id)
      Messages::Parser.new.call(message)

      message.tag_list
    end

    def extract_tag_ids(stringify = false)
      message = Message.new(body: @query, room_id: @room_id)
      Messages::Parser.new.call(message)
      result = message.tag_ids
      result.map(&:to_s) if stringify
    end

  end
end
