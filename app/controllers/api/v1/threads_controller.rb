class Api::V1::ThreadsController < Api::V1::BaseController
  load_and_authorize_resource :room
  before_filter :load_cached_messages, only: :show

  def show
    respond_with @messages
  end

  private

  def load_cached_messages
    @messages = Message.cached(filters, params[:sort_dir], 0, 0).reverse!
  end

  def filters
    @_filters ||= {
      room_id: @room.id,
      parent_id: params[:id]
    }
  end
end
