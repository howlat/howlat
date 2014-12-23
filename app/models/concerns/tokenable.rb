module Tokenable
  extend ActiveSupport::Concern

  included do

    before_create :generate_token
    after_update :update_timestamp_of_api_key

    def reset_token!
      generate_token && save
    end

    private

    def generate_token
      token_generator = ::Generators::Token.new
      self.token = loop do
        random_token = token_generator.generate
        break random_token unless self.class.exists?(token: random_token)
      end
    end

    def update_timestamp_of_personal_api_key
      api_key.touch
    end

  end
end
