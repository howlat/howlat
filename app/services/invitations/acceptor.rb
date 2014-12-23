require 'active_record'

module Invitations
  class Acceptor
    include ActiveModel::Validations

    attr_reader :invitation, :user, :email, :room

    validates_presence_of :invitation, :user, :email, :room

    def initialize(invitation, user)
      @invitation = invitation
      @user = user
      @room = invitation.try(:room)
      @email = invitation.try(:email)
    end

    def call
      return false unless valid?
      begin
        ActiveRecord::Base.transaction do
          # create organization member if not exists
          if @room.owner.respond_to? :memberships
            @room.owner.memberships.where(user_id: @user.id).first_or_create!
          end
          # add user to room
          @room.memberships.where(user_id: @user.id).first_or_create!
          # destroy this invitation
          @invitation.destroy!
          # cleanup similar invitations
          # NOTE: As we not allow many identical invitation to same room,
          #       this is useless
          #@room.invitations.where(email: [@email, @user.email]).destroy_all
        end
      rescue ActiveRecord::RecordInvalid
        return false
      end
      true
    end

  end
end
