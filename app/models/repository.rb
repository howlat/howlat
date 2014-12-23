class Repository < ActiveRecord::Base
  include Inheritable::Sti

  NAME_FORMAT = Room::NAME_FORMAT

  TYPES = {
    github: 'Repositories::GithubRepository',
    bitbucket: 'Repositories::BitbucketRepository'
  }.freeze

  act_as_sti(TYPES)

  belongs_to :room, inverse_of: :repository

  validates :room, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def connected?
    hook_id?
  end

end
