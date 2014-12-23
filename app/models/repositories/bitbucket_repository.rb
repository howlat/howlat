module Repositories
  class BitbucketRepository < Repository
    alias_attribute :service_id, :hook_id
  end
end
