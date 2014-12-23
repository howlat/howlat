class RoomsController < ApplicationController
  before_filter :require_login
  #load_resource :owner, find_by: :name, id_param: :name, class: 'Account'
  load_and_authorize_resource
  load_and_authorize_resource id_param: :name, find_by: :name
  load_and_authorize_resource :repository, through: :room, except: :index, singleton: true
  before_filter :find_or_create, only: :create

  def index
    @rooms = @rooms.uniq.page params[:page]
  end

  def show
    session[:room_id] = @room.id
    current_user.room_memberships.where(room_id: @room.id).first_or_create
    current_user.rooms.unhide(@room.id)

    render :show, layout: 'chatroom'
  end

  def new
  end

  def edit
  end

  def create
    service = Rooms::Creator.new(@room)
    service.as(current_user).call
    respond_with(service.room)
  end

  def update
    @room.update(room_params)
    respond_with(@room)
  end

  def destroy
    service = Repositories::Connector.new(current_user)
    service.disconnect(@room.repository)
    @room.destroy
    redirect_to({ action: :index }, notice: "Room has been deleted" )
  end

  def leave
    current_user.rooms.leave(@room.id)
    respond_to do |format|
      format.html { redirect_to @organization, notice: "You have left #{@room.name}"}
    end
  end

  private

  def room_params
    params.require(:room).permit(:name, :access, :access_policy, repository_attributes: [:name, :type])
  end

  def find_or_create
    return unless params[:find_or_create].to_i == 1
    repo = Repository.find_by(name: @room.repository.name)
    redirect_to(repo.room) if repo
  end

end
