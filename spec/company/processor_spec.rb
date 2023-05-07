# frozen_string_literal: true

require_relative "../../lib/company/processor"
require_relative "../../lib/company/validator"

RSpec.describe Company::Processor do
  let(:valid_data) do
    [{
      id: 1,
      name: "Blue Cat Inc.",
      top_up: 71,
      email_status: false
    }]
  end

  let(:invalid_data) do
    [{
      id: 2,
      name: "Purple Dog Co.",
      top_up: "not_an_integer",
      email_status: "not_a_boolean"
    }]
  end

  let(:validator) { Company::Validator }

  context "with valid data" do
    it "returns a hash of companies" do
      processor = described_class.new(valid_data, validator)

      result = processor.perform

      expect(result).to be_a(Hash)
      expect(result.size).to eq(1)
      expect(result[1].name).to eq("Blue Cat Inc.")
    end
  end

  context "with invalid data" do
    it "outputs error messages for invalid companies" do
      processor = described_class.new(invalid_data, validator)
      expect { processor.perform }.to output(/Invalid company data/).to_stdout
    end

    it "returns a hash of valid companies" do
      processor = described_class.new(invalid_data + valid_data, validator)

      result = processor.perform

      expect(result).to be_a(Hash)
      expect(result.size).to eq(1)
      expect(result[1].name).to eq("Blue Cat Inc.")
    end
  end

  context "with nil data" do
    it "returns an empty hash" do
      processor = described_class.new(nil, validator)

      result = processor.perform

      expect(result).to be_a(Hash)
      expect(result).to be_empty
    end
  end

  context "with an empty array" do
    it "returns an empty hash" do
      processor = described_class.new([], validator)

      result = processor.perform

      expect(result).to be_a(Hash)
      expect(result).to be_empty
    end
  end
end
