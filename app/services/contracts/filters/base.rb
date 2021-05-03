module Contracts
  module Filters
    class Base
      COMPARATORS = %w(eq gt lt gte lte).freeze

      attr_reader :scope, :parameters

      def initialize(scope, parameters)
        @scope = scope
        @parameters = parameters
      end

      def apply
        validate!
        scope.where(field => { "$#{parameters[:c]}" => parameters[:v] })
      end

      private

      def field
        raise NotImplemented
      end

      def validate!
        return if parameters[:v].present? && COMPARATORS.include?(parameters[:c]) 

        raise ArgumentError, "invalid options for #{self.class.name} filter"
      end
    end
  end
end
