require 'rooms/chat'

class GithubMessage < Message

  tire.index_name superclass.tire.index_name

  after_create :notify_chat_room

  def author
    @author ||= SystemUser.new
  end

  def notify_chat_room
    Rooms::Chat.new(room.jid).send_message(body, id)
  end

end
