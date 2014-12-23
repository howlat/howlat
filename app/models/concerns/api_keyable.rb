module ApiKeyable
  extend ActiveSupport::Concern

  module ClassMethods

    def api_keyable(class_name)
      class_eval do
        has_one :api_key,
          dependent: :destroy,
          class_name: class_name
        delegate :token, to: :api_key
        after_create { create_api_key }
      end
    end
  end
end
