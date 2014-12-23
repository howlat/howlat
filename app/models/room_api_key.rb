class RoomApiKey < ApiKey

  belongs_to :room, inverse_of: :api_key

  validates :room_id, presence: true

end
