class UserSerializer < ApplicationSerializer

  attributes :id, :name, :avatar_url, :fullname, :email, :last_activity_at, :jid

end
