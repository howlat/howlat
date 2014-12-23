class UserActivityLastLoginFromIp < ActiveRecord::Migration
    def self.up
      add_column :users, :last_login_from_ip_address, :string, :default => nil    
    end
  
    def self.down   
      remove_column :users, :last_login_from_ip_address
    end
end
