class UserMailer < ActionMailer::Base
  default from: "notifications@howlat.me"

  def invitation_message(invited_by,invitation)
  	@invitation = invitation
  	@invited_by = invited_by
    mail(to: @invitation.email, subject: with_app_name("You have been invited to '#{@invitation.room.name}' by #{@invited_by.fullname}"))
  end

  def invitation_canceled(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: with_app_name("Your invitation to '#{@invitation.room.name}' has been canceled"))
  end

  def remove_from_room(user, room)
    @user = user
    @room = room
    @organization = room.owner
    mail(to: @user.email, subject: with_app_name("You have been removed from '#{@room.name}' room in #{@organization.name}"))
  end

  def remove_from_organization(member, organization)
    @user = User.find(member.user_id)
    @organization = organization
    mail(to: @user.email, subject: with_app_name("You have been removed from #{@organization.name} organization"))
  end

  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(to: user.email, subject: with_app_name("Password Reset Instructions"))
  end

  def mention_message(message_id, mentioned_id)
    @message = Message.find(message_id)
    @mentioned = User.find(mentioned_id)
    @room = @message.room
    title = "#{@message.author.fullname} mentioned you in #{@room.name}"
    mail(to: @mentioned.email, subject: with_app_name(title))
  end

  private

  def with_app_name(subject)
    "[Howlat] #{subject}".strip
  end
end


