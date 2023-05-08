# frozen_string_literal: true

# returns a Hash of companies<company_id, DTO::Company> with ID as the key
module Company
  class CompanyRecords
    def initialize(filename)
      @filename = filename
    end

    def companies
      extracted_company_records = FileLoader.new(@filename).load_data
      company_processor = Company::Processor.new(extracted_company_records, Company::Validator)
      company_processor.perform
    end
  end
end
