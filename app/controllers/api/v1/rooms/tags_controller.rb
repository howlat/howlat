class Api::V1::Rooms::TagsController  < Api::V1::BaseController
  load_and_authorize_resource :room
  load_and_authorize_resource through: :room

  skip_filter :register_last_activity_time_to_db, only: :index

  def index
    @tags = @tags.where(type: tags_type) if tags_type
    respond_with @tags.collect(&:to_label)
  end

  private

  def tags_type
    params[:type]
  end

end
