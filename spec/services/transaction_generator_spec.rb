require_relative "../../lib/services/transaction_generator"
require_relative "../../lib/dto/user"
require_relative "../../lib/dto/company"

RSpec.describe Services::TransactionGenerator do
  let(:users) { {} }
  let(:companies) { {} }

  describe "#perform" do
    subject(:transaction_generator) { described_class.new(users: users, companies: companies) }

    context "when users and companies are nil" do
      let(:users) { nil }
      let(:companies) { nil }

      it "does not create any transactions" do
        expect { transaction_generator.perform }.not_to output.to_stdout
      end
    end

    context "when there are no users and companies" do
      it "does not create any transactions" do
        expect { transaction_generator.perform }.not_to output.to_stdout
      end
    end

    context "when there are no matching companies for users" do
      let(:users) do
        {
          1 => DTO::User.new(
            id: 1, first_name: "John",
            last_name: "Doe",
            email: "john.doe@example.com",
            company_id: 1,
            email_status: true,
            active_status: true,
            tokens: 100
          ),
          2 => DTO::User.new(
            id: 2, first_name: "Jane",
            last_name: "Doe",
            email: "jane.doe@example.com",
            company_id: 2,
            email_status: true,
            active_status: true,
            tokens: 50
          )
        }
      end

      let(:companies) do
        {
          1 => DTO::Company.new(id: 1, name: "Company A", top_up: 50)
        }
      end

      it "does not create any transactions for the users without matching companies" do
        expect { transaction_generator.perform }.to output("Company does not exist 2\n").to_stdout
      end

      it "creates transactions only for the users with matching companies" do
        expect(transaction_generator.perform).to match(
          1 => [
            an_instance_of(DTO::Transaction)
          ]
        )
      end
    end

    context "when all users have matching companies" do
      let(:users) do
        {
          1 => DTO::User.new(
            id: 1, first_name: "John",
            last_name: "Doe",
            email: "john.doe@example.com",
            company_id: 1,
            email_status: true,
            active_status: true,
            tokens: 100
          ),
          2 => DTO::User.new(
            id: 2, first_name: "Jane",
            last_name: "Doe",
            email: "jane.doe@example.com",
            company_id: 2,
            email_status: true,
            active_status: true,
            tokens: 50
          )
        }
      end

      let(:companies) do
        {
          1 => DTO::Company.new(id: 1, name: "Company A", top_up: 50),
          2 => DTO::Company.new(id: 2, name: "Company B", top_up: 20)
        }
      end

      it "creates transactions for all users with matching companies" do
        expect(transaction_generator.perform).to match(
          1 => [
            an_instance_of(DTO::Transaction)
          ],
          2 => [
            an_instance_of(DTO::Transaction)
          ]
        )
      end
    end
  end
end
