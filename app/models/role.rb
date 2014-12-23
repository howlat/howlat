class Role < ActiveRecord::Base

  def self.owner
    @@owner ||= Rails.cache.fetch("role_owner"){find_by_name('owner')}
  end

  def self.admin
    @@admin ||= Rails.cache.fetch("role_admin"){find_by_name('admin')}
  end

  def self.member
    @@member ||= Rails.cache.fetch("role_member"){find_by_name('member')}
  end

end
