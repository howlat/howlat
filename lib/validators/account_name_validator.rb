module Validators
  class AccountNameValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors.add attribute, (options[:message] || "is invalid") unless
        value =~ /\A[a-z0-9][a-z0-9_-]+[a-z0-9]\z/i
    end
  end
end
