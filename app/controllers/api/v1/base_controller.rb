class Api::V1::BaseController < ActionController::Base
  include Api::V1::Authentication
  include Api::V1::Authorization

  respond_to :json
  skip_filter :register_last_activity_time_to_db
  before_action :register_last_activity_time_to_db,
    if: :last_activity_less_than_minute_ago

  rescue_from(ActionController::ParameterMissing) do |param_missing_exception|
    head :bad_request
  end

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    head :not_found
  end

  private

  def last_activity_less_than_minute_ago
    current_user.last_activity_at <= Time.now.utc - 1.minute
  end

  def default_serializer_options
    {
      root: false
    }
  end

  def current_room_id
    session[:room_id]
  end

end
