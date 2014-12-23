class PasswordResetForm
  include ActiveModel::Model

  attr_accessor :new_password

  validates_presence_of :new_password
  validates_confirmation_of :new_password
  validates_length_of :new_password, minimum: 4

  def initialize(user)
    @user = user
  end

  def submit(params)
    self.new_password = params[:new_password]
    self.new_password_confirmation = params[:new_password_confirmation]
    if valid?
      # the next line clears the temporary token and updates the password
      @user.change_password!(new_password)
    else
      false
    end
  end

end
