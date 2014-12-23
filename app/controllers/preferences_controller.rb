class PreferencesController < ApplicationController
  before_filter :require_login

  load_and_authorize_resource :user
  load_and_authorize_resource :preferences, through: :user, singleton: true

  def show
    render :edit
  end

  def edit
  end

  def update
    @preferences.update(preferences_params)
    respond_with(@user, @preferences, location: {action: :edit})
  end

  private

  def preferences_params
    params.require(:preferences).permit(:audio_volume, :audio_notification,
      :desktop_notification, :email_notification)
  end

  def resource_name
    'preferences'
  end
end
