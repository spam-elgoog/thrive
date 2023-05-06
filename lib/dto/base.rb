# frozen_string_literal: true

module DTO
  class Base
    def self.attributes(*attribute_names)
      attr_reader(*attribute_names)

      define_method(:initialize) do |**kwargs|
        attribute_names.each do |attr_name|
          instance_variable_set("@#{attr_name}", kwargs[attr_name])
        end
      end
    end
  end
end