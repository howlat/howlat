module Api
  class BootstrapSerializer < ActiveModel::Serializer
    attributes :user, :rooms, :authenticity_token, :current_room_id, :xmpp_url,
      :xmpp_domain

    def user
      UserSerializer.new(object.user)
    end

    def rooms
      room_options = { current_room_id: current_room_id }
      object.rooms.map { |room| RoomSerializer.new(room, room_options) }
    end

    class UserSerializer < ActiveModel::Serializer
      self.root = false
      attributes :id, :name, :jid, :avatar_url
      has_one :preferences
    end

    class RoomSerializer < ActiveModel::Serializer
      self.root = false
      attributes :id, :name, :slug, :jid, :url, :active

      def url
        room_friendly_path(object.name)
      end

      def active
        object.id == options[:current_room_id]
      end

    end

  end
end
