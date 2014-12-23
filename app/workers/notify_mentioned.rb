class NotifyMentioned
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(message_id)
    message = Message.find_by(id: message_id)
    send_notification(message.id, user_ids_to_notify(message)) if message
  end

  private

  def user_ids_to_notify(message)
    mentioned_ids = message.tags.user_tag.map(&:user_id)
    mentioned_ids = message.room.member_ids if mentioned_ids.include?('everyone')
    return [] if mentioned_ids.blank? or mentioned_ids.empty?

    users_ids_to_skip = active_user_ids(mentioned_ids)
    users_ids_to_skip.concat user_ids_without_email_notification(mentioned_ids)
    users_ids_to_skip << message.author_id
    mentioned_ids - users_ids_to_skip
  end

  def user_ids_without_email_notification(user_ids)
    User.without_email_notification.where(id: user_ids).pluck(:id)
  end

  def active_user_ids(user_ids)
    User.current_users.where(id: user_ids).pluck(:id)
  end

  def send_notification(message_id, mentioned_ids)
    mentioned_ids.each do |mentioned_id|
      UserMailer.mention_message(message_id, mentioned_id).deliver
    end
  end
end
