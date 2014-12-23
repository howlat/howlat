class InvitationsController < ApplicationController
  before_filter :preprocess_acceptance, only: [:accept]
  before_filter :require_login

  load_and_authorize_resource :organization, through: :current_user, except: [:accept]
  load_and_authorize_resource :room, through: :organization, except: [:accept]
  load_and_authorize_resource :invitation, through: :room, except: [:accept]

  load_resource find_by: :token, id_param: :token, only: [:accept]
  authorize_resource only: [:accept]

  def new
    @emails = @organization.users.without_access_to_room(@room).pluck(:email)
  end

  def create
    if @invitation.save
      UserMailer.delay.invitation_message(current_user, @invitation)
      respond_to do |format|
        format.js {}
      end
    else
      respond_to do |format|
        format.js { render :error, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invitation.destroy
    UserMailer.delay.invitation_canceled(@invitation)
    respond_to do |format|
      format.html { redirect_to @organization, notice: "You have canceled invitation to #{@invitation.room.name}"}
      format.js {}
    end
  end

  def accept
    if Invitations::Acceptor.new(@invitation, current_user).call
      redirect_to chat_organization_room_path(@invitation.room.organization.slug, @invitation.room.slug)
    else
      redirect_to after_sign_in_url, alert: 'Could not finalize your invitation process.'
    end
    cookies.delete :invitation
  end

  def resend
    UserMailer.delay.invitation_message(current_user, @invitation)
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def preprocess_acceptance
    @invitation = Invitation.find_by_token(params[:token])
    if @invitation
      cookies[:invitation] = {
        value: params[:token],
        expires: 30.minutes.from_now.utc
      }
      session[:email] = @invitation.email unless logged_in?
    end
  end

end
