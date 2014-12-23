require 'omniauth'

module Middlewares
  class OauthContextManager

    def initialize(application)
      @application = application
    end

    def call(env)
      raise OmniAuth::NoSessionError.new("You must provide a session to use OmniAuth.") unless env['rack.session']

      request = Rack::Request.new(env)
      env['rack.session']['oauth.context'] = request.params['context'] if request.params['context']
      @application.call(env)
    end

  end
end
