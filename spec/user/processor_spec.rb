# frozen_string_literal: true

require_relative "../../lib/dto/user"
require_relative "../../lib/user/validator"
require_relative "../../lib/user/processor"

RSpec.describe User::Processor do
  let(:valid_user_data) do
    [{
      id: 1,
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      company_id: 1,
      email_status: true,
      active_status: true,
      tokens: 100
    }]
  end

  let(:invalid_user_data) do
    [{
      id: 2
    }]
  end

  let(:mixed_user_data) do
    invalid_user_data + valid_user_data
  end

  let(:validator) { User::Validator }

  describe "#perform" do
    context "when given valid user data" do
      it "returns an hash of DTO::User objects" do
        processor = User::Processor.new(valid_user_data, validator)
        users = processor.perform

        expect(users).to be_an(Hash)
        expect(users).to match(
          {
            1 => be_an_instance_of(DTO::User)
          }
        )
      end
    end

    context "when given invalid user data" do
      it "prints an error message and returns an empty hash" do
        processor = User::Processor.new(invalid_user_data, validator)
        expect {
          users = processor.perform
          expect(users).to eq({})
        }.to output(/Invalid user data: #{invalid_user_data.first}/).to_stdout
      end
    end

    context "when given mixed user data" do
      it "returns an hash of DTO::User objects with one valid user" do
        processor = User::Processor.new(mixed_user_data, validator)
        users = processor.perform

        expect(users).to be_an(Hash)
        expect(users.size).to eq(1)
        expect(users[1]).to be_an_instance_of(DTO::User)
        expect(users[1].id).to eq(mixed_user_data.last[:id])
      end

      it "prints an error message for the incomplete user data" do
        processor = User::Processor.new(mixed_user_data, validator)
        expect {
          processor.perform
        }.to output(/Invalid user data: #{mixed_user_data.first}/).to_stdout
      end
    end
  end
end
