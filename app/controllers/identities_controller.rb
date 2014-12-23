class IdentitiesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user

  def destroy
    @identity.destroy
    redirect_to [:edit, @user]
  end

end
