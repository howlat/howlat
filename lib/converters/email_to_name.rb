module Converters
  class EmailToName

    def convert(email)
      email.to_s.split("@").first.gsub(/[.-]/,'_').split("_").map(&:capitalize).join(" ") rescue email
    end
  end
end
