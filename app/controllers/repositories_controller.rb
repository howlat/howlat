class RepositoriesController < ApplicationController
  before_filter :require_login
  load_and_authorize_resource :room
  load_and_authorize_resource through: :room, singleton: true, instance_name: :repository

  def show
    authorize! :edit, @repository
    render :edit
  end

  def edit
  end

  def connect
    @repository.assign_attributes(connection_params)
    service = Repositories::Connector.new(current_user)
    service.connect(@repository)
    respond_with(@room, @repository, status: :ok)
  end

  def disconnect
    service = Repositories::Connector.new(current_user)
    service.disconnect(@repository)
    respond_with(@room, @repository, status: :ok)
  end

  private

  def connection_params
    {}
  end

end
