module Messages
  module GithubMessages
    class Builder

      def initialize(parameters, event, room)
        @parameters = JSON.parse(parameters)
        @event = event
        @room = room
        @message = nil
        @builder = builder_for_event(@event)
      end

      def call
        return nil unless @builder

        @message = GithubMessage.new(parameters: @parameters, tags: [],
          room_id: @room.id)
        @message.tags.add("github:#{@event.singularize}")

        return nil unless @builder.call(@message)

        @message
      end

      def builder_for_event(event)
        "Messages::GithubMessages::Builders::#{event.singularize.classify}"
          .safe_constantize.try(:new)
      end
    end
  end
end
