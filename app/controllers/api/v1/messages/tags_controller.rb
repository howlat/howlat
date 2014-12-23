class Api::V1::Messages::TagsController < Api::V1::BaseController
  load_and_authorize_resource :room
  load_and_authorize_resource :message, through: :room

  def create
    @message.tags.add(tag_to_add)
    render json: { tags: @message.tag_list }, status: :ok
  end

  def destroy
    @message.tags.remove(tag_to_remove)
    render json: { tags: @message.tag_list }, status: :ok
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def tag_to_add
    tag_params.require(:name)
  end

  def tag_to_remove
    params.require(:name)
  end

end
