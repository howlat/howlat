module Rooms
  class Creator
    attr_accessor :room

    def initialize(room)
      @room = room
    end

    def as(user)
      @user = user
      self
    end

    def call(options = {})
      @room.class.transaction do
        @room.save!(options)
        @room.members << @user
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
  end
end
