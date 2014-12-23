class BadgesController < ApplicationController
  load_resource :room, id_param: :name, find_by: :name
  load_and_authorize_resource through: :room, singleton: true
  skip_filter :register_last_activity_time_to_db

  def show
    respond_to do |format|
      format.png { send_data(@badge.image , type: 'image/png') }
    end
  end

end
