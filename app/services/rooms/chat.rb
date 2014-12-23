require 'xmpp4r'
require 'xmpp4r/muc'
require 'xmpp4r/roster'
require 'xmpp4r/client'

module Rooms
 class Chat
  attr_accessor :client, :muc, :chat_room

  def initialize(room_jid)
    @client = Jabber::Client.new(Jabber::JID.new(SystemUser.new.jid))
    @client.connect
    @client.auth('password')
    join_room(room_jid)
  end

 	def send_message(body, id)
    message = Jabber::Message.new(@chat_room, body).set_id(id)
    muc.send(message)
 	end

  def join_room(room_jid)
    @chat_room = room_jid
    @muc = Jabber::MUC::MUCClient.new(@client)
    @muc.join(Jabber::JID::new(room_jid+"/"+@client.jid.node))
  end

 end
end
