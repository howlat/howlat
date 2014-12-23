module Api
  class Bootstrap
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :user, :rooms, :authenticity_token, :current_room_id

    def xmpp_url
      ENV['XMPP_URL']
    end

    def xmpp_domain
      ENV['XMPP_DOMAIN']
    end
  end
end
