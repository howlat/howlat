class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :room

  validates :email, presence: true, :'validators/email' => true,
    uniqueness: { scope: :room_id }, room_membership: true
  validates :room_id, presence: true

end
