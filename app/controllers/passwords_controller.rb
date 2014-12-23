class PasswordsController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource :user
  helper_method :password_change_form

  def update
    success = password_change_form.submit(password_params)
    flash.now[:notice] = 'Password updated' if success
    render 'users/edit'
  end

  private

  def password_change_form
    @password_change_form ||= PasswordChangeForm.new(@user)
  end

  def password_params
    params.require(:password).permit(:current_password, :new_password,
      :new_password_confirmation)
  end

end
