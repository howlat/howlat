class PersonalApiKeyAbility < UserAbility

  def initialize(api_key)
    super(api_key.user)
  end

end
