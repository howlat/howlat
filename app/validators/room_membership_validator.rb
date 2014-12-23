class RoomMembershipValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    room_id = options.fetch(:room_id, record.try(:room_id))
    user_id = options.fetch(:user_id, User.find_by(attribute => value))
    message = options[:message] || :room_membership
    already_member = RoomMembership.where(user_id: user_id, room_id: room_id).exists?

    record.errors.add attribute, message if already_member
  end

end
