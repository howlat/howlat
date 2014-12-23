class RoomMembership < ActiveRecord::Base

  belongs_to :user, inverse_of: :room_memberships
  belongs_to :room, inverse_of: :memberships

  validates :user_id, presence: true, uniqueness: { scope: :room_id }
  validates :room_id, presence: true

end
