# frozen_string_literal: true
require_relative '../dto/company'

module Company
  class Processor
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
        company = DTO::Company.new(**company.transform_keys(&:to_sym))
        company_store[company.id] = company
      end
    end

    private

    def valid?(record)
      @validator.validate_json(record)
    end
  end
end