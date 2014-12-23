class OrganizationMembership < ActiveRecord::Base

  belongs_to :user
  belongs_to :organization

  validates :user_id, presence: true, uniqueness: { scope: :organization_id }
  validates :organization_id, presence: true

end
