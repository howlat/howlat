class SessionsController < ApplicationController
  skip_authorization_check
  layout 'authentication'

  def new
  end

  def create
    @user = Authentication::Service.new(:email_password).call(session_params)
    if @user
      auto_login(@user)
      session[:email] = nil
      redirect_back_or_to after_sign_in_url, notice: "You have been signed in successfully!"
    else
      flash.now.alert = "Email address or password was incorrect. Please, try again."
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_url, notice: "You have been signed out successfully!"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end

end
