module Parsable
  extend ActiveSupport::Concern

  included do
    before_validation :run_parsers

    private

    def run_parsers
      self.class.parsers.each do |parser|
        parser.safe_constantize.try(:new).try(:call, self)
      end if self.class.parsers?
    end

  end

  module ClassMethods

    def parsers
      @@parsers ||= []
    end

    def parsers?
      parsers && !parsers.empty?
    end

  end
end

