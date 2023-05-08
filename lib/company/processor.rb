# frozen_string_literal: true

require "logger"
require_relative "../dto/company"

module Company
  class Processor
    DTO_KLASS = DTO::Company

    def initialize(data, validator)
      @data = data || []
      @validator = validator
    end

    def perform
      @data.each_with_object({}) do |company, company_store|
        unless valid?(company)
          puts "Invalid company data: #{company}"
          next
        end
        company = DTO_KLASS.new(**company)
        if company_store[company.id]
          puts "WARN - Company record with the same id. "\
            "No tokens will be processed for duplicate #{company.inspect}."
          next
        end
        company_store[company.id] = company
      end
    end

    private

    def valid?(record)
      @validator.validate_json(record)
    end

    def logger
      @logger ||= Logger.new("logs.log")
    end
  end
end
