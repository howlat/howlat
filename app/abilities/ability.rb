class Ability

  def self.for(object)
    return GuestAbility.new(object) unless object
    "#{object.class}Ability".safe_constantize.new(object)
  end

end
