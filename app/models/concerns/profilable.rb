module Profilable
  extend ActiveSupport::Concern

  included do
    if ancestors.include?(::ActiveRecord::Base)
      has_one :profile, dependent: :destroy
      accepts_nested_attributes_for :profile
    end

    def display_name
      profile.try(:name) || name
    end
    alias_method :fullname, :display_name

    def avatar_url
      profile.try(:avatar).try(:url)
    end

  end
end

