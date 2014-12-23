module Authentication
  class Service

    def initialize(strategy = :email_password, user_class = User, api_key_class = ApiKey)
      @strategy_class = "Authentication::Strategies::#{strategy.to_s.classify}".safe_constantize rescue nil
      @strategy_class ||= Strategies::EmailPassword
      @strategy = @strategy_class.new(user_class, api_key_class)
    end

    # returns user or nil
    def call(credentials)
      @strategy.authenticate(credentials)
    end
  end
end
