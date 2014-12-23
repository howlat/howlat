class PasswordResetsController < ApplicationController
  skip_authorization_check
  skip_before_filter :require_login
  before_filter :authorize_reset_password_token!, only: [:edit, :update]
  layout 'authentication'

  def new
    @user = User.new
  end

  # request password reset.
  # you get here when the user entered his email in the reset password form and submitted it.
  def create
    @user = User.find_by_email(user_params[:email]) if user_params[:email].present?

    if @user
      # Reset session when logged in user resets his password
      logout if logged_in?
      # This line sends an email to the user with instructions on how to reset their password (a url with a random token)
      @user.deliver_reset_password_instructions!
    end
    # Tell the user instructions have been sent whether or not email was found.
    # This is to not leak information to attackers about which emails exist in the system.
    render
  end

  # This is the reset password form.
  def edit
    @form = PasswordResetForm.new(@user)
  end

  # This action fires when the user has sent the reset password form.
  def update
    @form = PasswordResetForm.new(@user)
    if @form.submit(password_params)
      render
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def password_params
    params.require(:password).permit(:new_password, :new_password_confirmation)
  end

  def authorize_reset_password_token!
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end
end
