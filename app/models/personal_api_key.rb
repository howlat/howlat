class PersonalApiKey < ApiKey
  belongs_to :user, inverse_of: :api_key
  validates :user_id, presence: true
end
