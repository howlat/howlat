class Api::V1::MessagesController < Api::V1::BaseController
  load_and_authorize_resource :room
  before_filter :load_cached_messages, only: :index
  load_and_authorize_resource through: :room
  before_filter :check_if_upload, only: :create

  def index
    respond_with @messages
  end

  def search
    @messages = Message.search(params[:query], @room.id, params[:page],
      params[:per_page]).to_a
    respond_with @messages
  end

  def new
    respond_with @message
  end

  def edit
    respond_with @message
  end

  def show
    respond_with @message if stale?(@message)
  end

  def create
    if @message.save
      render json: @message
    else
      render status: :unprocessable_entity, json: @message.errors
    end
  end

  def update
    if @message.update(message_params)
      render json: @message
    else
      render status: :unprocessable_entity, json: @message.errors
    end
  end

  def destroy
    @message.destroy
    head :ok
  end

  private

  def load_cached_messages
    @messages = Message
                .cached(filters, params[:sort_dir], params[:page])
                .reverse!
  end

  def check_if_upload
    if @message.attachment_file_name != nil
      @message.type = "chat";
      @message.body = @message.attachment_url
    end
  end

  def filters
    @_filters = { room_id: @room.id }
    [:type, :parent_id].each do |filter|
      @_filters[filter] = params[filter] if params[filter].present?
    end
    @_filters
  end

  def message_params
    params.require(:message)
      .permit(:body, :attachment, :parent_id, :type)
      .merge(room_id: (@room ? @room.id : nil), author_id: current_user.id)
  end

end
