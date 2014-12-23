class Room < ActiveRecord::Base
  extend Enumerize
  include Sluggable
  include ApiKeyable
  api_keyable 'RoomApiKey'
  NAME_FORMAT = /[\w\-]+\/[\w\-\.]+/

  enumerize :access, in: %w(public private), predicates: true
  enumerize :access_policy, in: %w(github)

  scope :public, -> { where(access: 'public') }
  scope :private, -> { where(access: 'private') }
  scope :visible_for, ->(user_id) {
    joins(:memberships)
    .where(room_memberships: {room_hidden: false, user_id: user_id})
  }

  belongs_to :owner, class_name: 'Account'
  has_many :members, through: :memberships, uniq: true, class_name: 'User', source: :user
  has_many :memberships, class_name: 'RoomMembership', dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :threads, ->() { where.not(parent_id: nil).includes(:children) }, class_name: 'Message'
  has_many :tags, through: :messages, uniq: true
  has_one :repository, dependent: :destroy, inverse_of: :room

  accepts_nested_attributes_for :repository

  validates :name, presence: true, uniqueness: { scope: :owner_id },
    format: { with: NAME_FORMAT }
  validates :slug, presence: true, uniqueness: { scope: :owner_id }
  validates :access, presence: true, inclusion: { in: Room.access.values }
  validates :access_policy, inclusion: { in: Room.access_policy.values },
    allow_nil: true

  def jid
    [slug, "@conference.#{ENV['XMPP_DOMAIN']}"].join
  end

  def integrations
    [repository || build_repository]
  end

  def badge
    @badge ||= Badge.new(room: self)
  end

end
