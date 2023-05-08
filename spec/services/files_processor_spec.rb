require "spec_helper"
require_relative "../../lib/services/ledger_generator"

RSpec.describe Services::FilesProcessor do
  describe "#initialize" do
    context "when filenames are not provided" do
      it "uses default filenames" do
        files_processor = Services::FilesProcessor.new
        expect(files_processor.instance_variable_get(:@users_filename)).to eq(
          File.join(Dir.pwd, "data", "users.json")
        )
        expect(files_processor.instance_variable_get(:@companies_filename)).to eq(
          File.join(Dir.pwd, "data", "companies.json")
        )
      end
    end

    context "when filenames are provided" do
      it "uses provided filenames" do
        files_processor = Services::FilesProcessor.new(
          users_filename: "my_users.json",
          companies_filename: "my_companies.json"
        )
        expect(files_processor.instance_variable_get(:@users_filename)).to eq("my_users.json")
        expect(files_processor.instance_variable_get(:@companies_filename)).to eq("my_companies.json")
      end
    end
  end

  describe "#process" do
    let(:transactions) {
      {
        1 => [
          DTO::Transaction.new(
            company_id: 2, user_id: 1, previous_balance: 5, top_up: 10, processed_at: Time.new(2023, 5, 8, 12, 0, 0)
          )
        ]
      }
    }
    let(:active_users) {
      {
        1 => {
          id: 1,
          first_name: "Tanya",
          last_name: "Nichols",
          email: "tanya.nichols@gmail.com",
          company_id: 2,
          email_status: true,
          active_status: false,
          tokens: 23
        }
      }
    }
    let(:valid_companies) {
      {
        2 =>
          DTO::Company.new(
            id: 2,
            name: "Blue Cat Inc.",
            top_up: 71,
            email_status: false
          )
      }
    }
    let(:ledger_generator) { double("ledger_generator", generate_ledger: "ledger") }

    before do
      allow_any_instance_of(Services::FilesProcessor).to receive(:transactions).and_return(transactions)
      allow_any_instance_of(Services::FilesProcessor).to receive(:active_users).and_return(active_users)
      allow_any_instance_of(Services::FilesProcessor).to receive(:valid_companies).and_return(valid_companies)
      allow(Services::LedgerGenerator).to receive(:new).and_return(ledger_generator)
      allow(Printer).to receive(:print_to_file)
      allow(Printer).to receive(:print_to_stdout)
    end

    it "generates a ledger and prints it to file and stdout" do
      files_processor = Services::FilesProcessor.new
      expect(ledger_generator).to receive(:generate_ledger)
      expect(Printer).to receive(:print_to_file).with("output.txt", "ledger")
      expect(Printer).to receive(:print_to_stdout).with("ledger")

      files_processor.process
    end
  end
end
