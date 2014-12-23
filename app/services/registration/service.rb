module Registration
  class Service

    def initialize(strategy = :form, user_class = User)
      @strategy_class = "Registration::Strategies::#{strategy.to_s.classify}".safe_constantize
      @strategy_class ||= Strategies::Form
      @strategy = @strategy_class.new(user_class)
    end

    def call(registration_params)
      @strategy.register(registration_params)
    end

    def user
      @strategy.user
    end

  end
end
