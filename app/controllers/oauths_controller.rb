class OauthsController < ApplicationController
  Parameters = ActionController::Parameters
  skip_authorization_check
  before_filter :authorize_context
  before_filter :override_uid_and_provider_from_session, only: [:signup]
  after_filter :clear_context, only: [:callback]

  def callback
    switch_to_context
  end

  def failure
    flash.now[:alert] = params[:message]
  end

  def signup
    service = Registration::Service.new(:oauth)
    auth_service = Authentication::Service.new(:oauth)
    if user = auth_service.call(auth_params)
      auto_login(user)
      redirect_back_or_to(after_sign_in_url) and return
    elsif service.call(auth_params)
      auto_login(service.user)
      redirect_back_or_to(after_sign_in_url) and return
    elsif User.where(email: service.user.email).exists?
      message = <<-EOM
        Account with provided email address has been found.
        Therefore we have to confirm your identity for security reasons.
        Please login and link this #{provider_name} account under Login Settings.
      EOM
      reset_session
      session[:email] = service.user.email
      redirect_to(root_path, notice: message) and return
    else
      @user = service.user
      store_auth_params
      render 'signup'
    end
  end

  protected

  def connect
    success = Identities::Connector.new.call(current_user, auth_params)
    flash[:error] = "You cannot connect this #{provider_name} account,
      because it is already linked to other user." unless success
    redirect_to [:edit, current_user]
  end

  def signin
    @user = Authentication::Service.new(:oauth).call(auth_params)
    if @user
      auto_login(@user)
      redirect_back_or_to after_sign_in_url
    else
      signup
    end
  end

  def integration
    session['oauth.token'] = token
    redirect_to origin
  end

  private

  def authorize_context
    require_login if context.eql?('connect')
  end

  def switch_to_context
    if %w(signup connect signin integration).include?(context)
      send context.to_sym
    else
      redirect_to root_url, alert: 'Invalid OAuth context.'
    end
  end

  def override_uid_and_provider_from_session
    s_provider = retrieve_auth_params['provider']
    s_uid = retrieve_auth_params['uid']
    params['provider'] = s_provider if s_provider
    params['uid'] = s_uid if s_uid
  end

  def context
    session['oauth.context'] || 'signin'
  end

  def clear_context
    session['oauth.context'] = nil
  end

  def provider_name
    provider = (params[:provider] || auth_params.fetch('provider')).to_s
    Identity.new(provider: provider).provider_name
  end

  def auth_params
    Parameters.new(env['omniauth.auth'] || signup_form_params).permit!
  end

  def origin
    env['omniauth.origin']
  end

  def token
    env['omniauth.auth'][:credentials][:token]
  end

  def signup_form_params
    converted_params = params.clone
      .merge(retrieve_auth_params.slice(:credentials, :info))
    converted_params[:info][:email] = params[:user][:email]
    converted_params.permit!
  end

  def store_auth_params
    session['oauth.cache.params'] = auth_params.slice(:credentials, :provider,
      :uid, :info)
  end

  def retrieve_auth_params
    session['oauth.cache.params']
  end

end
