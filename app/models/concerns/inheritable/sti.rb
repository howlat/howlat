require 'active_support/concern'
require 'active_support/hash_with_indifferent_access'

module Inheritable
  module Sti
    extend ActiveSupport::Concern

    included do

      # Single Table Inheritance map
      # format: { value => class_name }
      class_attribute :sti_map, instance_writer: false
      self.sti_map = ActiveSupport::HashWithIndifferentAccess.new

      # inheritance column validations
      validates inheritance_column, presence: true, inclusion: { in: ->(r) { r.class.sti_map.keys } }

    end

    module ClassMethods

      def act_as_sti(map = {})
        sti_map.merge!(map).freeze
        sti_map.each do |key, class_name|
          require_dependency class_name.underscore
          class_eval <<-RUBY
            scope :#{key.to_s.singularize}, ->() { where(#{inheritance_column}: '#{key}') }
          RUBY
        end
      end

      def sti_name
        sti_map.invert[self.to_s]
      end

      private

      def find_sti_class(type_name)
        candidate = sti_map[type_name]
        candidate ? candidate.to_s.safe_constantize : super
      end

      def subclass_value_from_attributes(attrs)
        attrs.with_indifferent_access[inheritance_column]
      end

      def subclass_from_attributes(attrs)
        subclass_value = subclass_value_from_attributes(attrs)
        super(inheritance_column => sti_map[subclass_value])
      end
    end

  end
end
