module Api
  module V1
    module Github
      class CallbacksController < Api::V1::Github::BaseController
        load_and_authorize_resource :room, through: :api_key, singleton: true

        def create
          service = ::Messages::GithubMessages::Builder.new(callback_params[:parameters],
            event, @room)
          @message = service.call
          head(:ok) and return unless @message # skip message creation for this callback

          authorize! :create, @message
          @message.save ? head(:ok) : head(:unprocessable_entity)
        end

        private

        def callback_params
          ActionController::Parameters.new(parameters: request.raw_post).permit!
        end

        def event
          request.headers['X-Github-Event']
        end

      end
    end
  end
end
