class UsersController < ApplicationController

  before_filter :require_login, except: [:new, :create]
  load_resource
  load_resource id_param: :name, find_by: :name
  authorize_resource
  helper_method :password_change_form

  def new
    @user.build_profile
    render :new, layout: 'authentication'
  end

  def show
  end

  def edit
  end

  def create
    service = Registration::Service.new(:form)
    created = service.call(user_params)
    @user = service.user
    if created
      auto_login(service.user)
      redirect_to after_sign_in_url, notice: "Successfully signed up!"
    else
      render :new, layout: 'authentication'
    end
  end

  def update
    @user.update(user_params)
    respond_with(@user, location: [:edit, @user])
  end

  def destroy
    @user.destroy
    logout
    redirect_to root_url
  end

  protected

  def password_change_form
    @password_change_form ||= PasswordChangeForm.new(@user)
  end

  private

  def user_params
    send "user_params_for_#{action_name}".to_sym
  end

  def user_params_for_create
    params.require(:user).permit(:name, :email, :password, profile_attributes: [:name])
  end

  def user_params_for_update
    params.require(:user).permit(:name, :email)
  end

end
