class Organization < Account

  has_many :members, through: :memberships, uniq: true, class_name: 'User'
  has_many :memberships, class_name: 'OrganizationMembership', dependent: :destroy

end
