require "application_responder"
require 'github/client'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :json, :html

  protect_from_forgery with: :exception

  check_authorization

  before_filter :check_for_pending_invitations
  before_filter :set_basic_javascript_variables

  helper_method :after_sign_in_url, :current_ability, :github

  def after_sign_in_url
    url_for(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
    access_denied_url = logged_in? ? current_user : root_url
    redirect_to access_denied_url, alert: exception.message
  end

  protected

  def github
    @github ||= ::Github::Client.for_user current_user
  end

  private

  def check_for_pending_invitations
    if logged_in? && cookies[:invitation].present?
      if !params[:controller].eql?('invitations') && !params[:action].eql?('accept')
        redirect_to(accept_invitation_path(token: cookies[:invitation]))
      end
    end
  end

  def not_authenticated
    redirect_to root_url, alert: "Please login to access this page"
  end

  def current_ability
    @current_ability ||= Ability.for(current_user)
  end

  def set_basic_javascript_variables
    gon.authenticity_token = form_authenticity_token
  end

  def current_room_id
    session[:room_id]
  end

end
