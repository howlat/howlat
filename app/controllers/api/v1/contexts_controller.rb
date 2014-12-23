class Api::V1::ContextsController < Api::V1::BaseController
  load_and_authorize_resource :room

  def show
    @messages = Message.context(params[:id], params[:room_id])
    respond_with @messages
  end

end