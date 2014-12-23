class Api::V1::Rooms::MembersController  < Api::V1::BaseController
  load_and_authorize_resource :room
  load_and_authorize_resource through: :room, class: 'User'

  def index
    respond_with @members
  end

  def show
  	respond_with @member
  end

end
