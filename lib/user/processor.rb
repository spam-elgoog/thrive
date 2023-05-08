# frozen_string_literal: true

require "logger"
require_relative "../dto/user"

# Creates an array of DTO::Users, validated records against a JSON schema
module User
  class Processor
    DTO_KLASS = DTO::User

    def initialize(data, validator)
      @data = data
      @validator = validator
    end

    def perform
      @data.each_with_object({}) do |user, user_store|
        unless valid?(user)
          log_messagge("Invalid user data: #{user.inspect}")
          next
        end

        user = DTO_KLASS.new(**user)

        if user_store[user.id]
          log_messagge("User record with the same id. No tokens will be processed for the user with duplicate id #{user.inspect}.")
          next
        end
        user_store[user.id] = user
      end
    end

    private

    def log_messagge(msg)
      logger.warn(msg)
      p(msg)
    end

    def valid?(user)
      @validator.validate_json(user)
    end

    def logger
      @logger ||= Logger.new("logs.log")
    end
  end
end
