require 'user/validator'

RSpec.describe User::Validator do
  describe '.validate_json' do
    let(:valid_data) do
      {
        "id": 1,
        "first_name": "Tanya",
        "last_name": "Nichols",
        "email": "tanya.nichols@gmail.com",
        "company_id": 2,
        "email_status": true,
        "active_status": false,
        "tokens": 23
      }
    end

    context 'with valid data' do
      it 'returns true' do
        expect(User::Validator.validate_json(valid_data)).to be true
      end
    end

    context 'with invalid data' do
      context 'when id is not an integer' do
        let(:invalid_data) { valid_data.merge(id: '1') }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end

      context 'when first_name is not a string' do
        let(:invalid_data) { valid_data.merge(first_name: 123) }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end

      context 'when last_name is not a string' do
        let(:invalid_data) { valid_data.merge(last_name: 123) }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end

      context 'when email is not a valid email address' do
        let(:invalid_data) { valid_data.merge(email: 'not_an_email') }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end

      context 'when company_id is not an integer' do
        let(:invalid_data) { valid_data.merge(company_id: '2') }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end

      context 'when email_status is not a boolean' do
        let(:invalid_data) { valid_data.merge(email_status: 'true') }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end

      context 'when active_status is not a boolean' do
        let(:invalid_data) { valid_data.merge(active_status: 'false') }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end

      context 'when tokens is not an integer' do
        let(:invalid_data) { valid_data.merge(tokens: '23') }

        it 'returns false' do
          expect(User::Validator.validate_json(invalid_data)).to be false
        end
      end
    end
  end
end