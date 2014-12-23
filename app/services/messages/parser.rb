module Messages
  class Parser

    def call(message)
      message.tags.add(*(Tags::Extractor.new.call(message)))
    end

  end
end
