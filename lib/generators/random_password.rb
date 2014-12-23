require 'securerandom'

module Generators
  class RandomPassword

    def generate
      SecureRandom.hex(16)
    end

  end
end
