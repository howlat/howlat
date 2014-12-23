class IdentityListPresenter < BasePresenter

  def initialize(object, helper, options = {})
    super
    @user = options.fetch(:user, current_user)
  end

  def identities
    @identities = @user.identities.to_a
    connected_providers = @identities.collect(&:provider)
    (Identity::PROVIDERS - connected_providers).each do |provider|
       @identities.push(@user.identities.build(provider: provider))
    end
    @identities.sort_by!(&:provider)
  end

  def cache_key
    [@user.cache_key, 'identities']
  end

end
