class PrivateRoomsController < ApplicationController
	before_filter :require_login

	def show
    @rooms = Room.accessible_by(current_ability).order(created_at: :asc)
    render :show, layout: 'room'
  end

  def create
    if @room.save
      @room.users << current_user
      redirect_to chat_organization_room_path(organization_slug: current_organization.slug, room_slug: @room.slug)
    else
      render action: :new
    end
  end

  def destroy
    @room.destroy
    redirect_to({ action: :index }, notice: "Room has been deleted" )
  end

private

  def load_room_from_slug
    @room = Room.accessible_by(current_ability).where(organization_id: @organization).find_by_slug!(params[:room_slug]) if params[:room_slug]
  end

  def room_params
    params.require(:room).permit(:name)
  end
end