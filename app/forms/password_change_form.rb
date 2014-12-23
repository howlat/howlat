class PasswordChangeForm
  include ActiveModel::Model

  attr_accessor :current_password, :new_password
  attr_reader :user

  validate :verify_current_password
  validates_presence_of :current_password, :new_password
  validates_confirmation_of :new_password
  validates_length_of :new_password, minimum: 4

  def initialize(user)
    @user = user
  end

  def submit(params)
    self.current_password = params[:current_password]
    self.new_password = params[:new_password]
    self.new_password_confirmation = params[:new_password_confirmation]
    if valid?
      @user.password = new_password
      @user.save
    else
      false
    end
  end

  def verify_current_password
    unless User.authenticate(@user.email, current_password)
      errors.add :current_password, "is not correct"
    end
  end

end
