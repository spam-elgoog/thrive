# frozen_string_literal: true
require_relative '../dto/user'

module User
  class Processor
    DTO_KLASS = DTO::User

    def initialize(data, validator)
      @data = data
      @validator = validator
    end

    def perform
      @data.each_with_object([]) do |user,arr|
        unless valid?(user)
          puts "Invalid user data: #{user}"
          next
        end
        
        arr << DTO_KLASS.new(**user)
      end
    end

    private

    def valid?(user)
      @validator.validate_json(user)
    end
  end
end
