class HomeController < ApplicationController
  before_filter ->() { redirect_to after_sign_in_url if current_user }
  skip_authorization_check

  def index
  end
end
