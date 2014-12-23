class Api::V1::BootstrapsController < Api::V1::BaseController
  load_and_authorize_resource :user, through: :api_key, singleton: true

  def show
    @bootstrap = Api::Bootstrap.new(user: user, rooms: rooms,
      authenticity_token: form_authenticity_token,
      current_room_id: current_room_id)
    respond_with @bootstrap, serializer: ::Api::BootstrapSerializer
  end

  private

  def rooms
    @rooms ||= Room.accessible_by(current_ability)
      .order(created_at: :asc)
      .visible_for(@user)
      .uniq
  end

  def user
    @user
  end
end
