class Account < ActiveRecord::Base
  include Profilable

  validates :name, presence: true, uniqueness: { case_sensitive: false },
    :'validators/account_name' => true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
    :'validators/email' => true

  before_validation :preprocess_attributes!

  def jid
    [id, '.', name, '@', ENV['XMPP_DOMAIN']].join
  end

  private

  def preprocess_attributes!
    self.name = name.to_s.downcase.delete(' ')
    self.email = email.to_s.downcase.delete(' ')
  end

end
