class Api::V1::RoomsController < Api::V1::BaseController
  load_and_authorize_resource :user, through: :api_key, singleton: true
  load_and_authorize_resource

  def hide
    @user.rooms.hide(@room.id)
    head :ok
  end

  private

  def room_params
    params.require(:room).permit(:tab_index)
  end

end
