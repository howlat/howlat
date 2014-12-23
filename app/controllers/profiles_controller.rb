class ProfilesController < ApplicationController
  before_filter :require_login, except: [:new, :create]
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user, singleton: true

  def show
    redirect_to(action: :edit)
  end

  def edit
  end

  def update
    @profile.update(profile_params)
    respond_with(@user, @profile, location: {action: :edit})
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :email, :avatar, :location,
      :company, :website, :description, :avatar_provider_id, :reset_avatar)
  end

end
