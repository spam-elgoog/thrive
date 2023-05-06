require_relative '../../lib/company/validator'

RSpec.describe Company::Validator do
  describe '.validate_json' do
    context 'when the company data is valid' do
      let(:company_data) do
        {
          "id": 1,
          "name": "Blue Cat Inc.",
          "top_up": 71,
          "email_status": false
        }
      end

      it 'returns true' do
        expect(described_class.validate_json(company_data)).to be true
      end
    end

    context 'when the company data is invalid' do
      let(:company_data) do
        {
          "id": 2,
          "top_up": 100
        }
      end

      it 'returns false' do
        expect(described_class.validate_json(company_data)).to be false
      end
    end
  end
end
