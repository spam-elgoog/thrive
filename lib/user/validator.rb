# frozen_string_literal: true

require 'json'
require 'json-schema'

module User
  class Validator
    class << self
      def validate_json(data)
        JSON::Validator.validate(USER_SCHEMA, data)
      end
    end
  end

  USER_SCHEMA = {
    "title": "User",
    "type": "object",
    "required": [
      "id",
      "first_name",
      "last_name",
      "email",
      "company_id",
      "email_status",
      "active_status",
      "tokens"
    ],
    "properties": {
      "id": {
        "type": "integer"
      },
      "first_name": {
        "type": "string"
      },
      "last_name": {
        "type": "string"
      },
      "email": {
        "type": "string",
        "pattern": "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        "format": "email"
      },
      "company_id": {
        "type": "integer"
      },
      "email_status": {
        "type": "boolean"
      },
      "active_status": {
        "type": "boolean"
      },
      "tokens": {
        "type": "integer"
      }
    },
  }.freeze
end
