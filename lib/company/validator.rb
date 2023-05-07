# frozen_string_literal: true

require "json"
require "json-schema"

module Company
  class Validator
    class << self
      def validate_json(company)
        JSON::Validator.validate(COMPANY_SCHEMA, company)
      end
    end
  end

  COMPANY_SCHEMA = {
    title: "Company",
    type: "object",
    properties: {
      id: {
        type: "integer"
      },
      name: {
        type: "string"
      },
      top_up: {
        type: "integer"
      },
      email_status: {
        type: "boolean"
      }
    },
    required: [
      "id",
      "name",
      "top_up",
      "email_status"
    ]
  }.freeze
end
