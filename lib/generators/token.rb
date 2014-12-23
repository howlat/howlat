require 'securerandom'

module Generators
  class Token

    def generate
      SecureRandom.hex(32)
    end

  end
end
