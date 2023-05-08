# frozen_string_literal: true

require "require_all"
require_all "lib"

module Services
  class FilesProcessor
    # TODO: Put this in a yaml file?
    DATA_FILES_INFO = {
      file_directory: "data",
      file_names: {
        users: "users.json",
        companies: "companies.json"
      },
      output_filename: "output.txt"
    }.freeze

    def initialize(users_filename: nil, companies_filename: nil)
      @users_filename = users_filename ||
        get_data_path(DATA_FILES_INFO.dig(:file_names, :users))
      @companies_filename = companies_filename ||
        get_data_path(DATA_FILES_INFO.dig(:file_names, :companies))
    end

    def process
      transactions

      ledger = LedgerGenerator.new(
        transactions: notify_users,
        active_users: active_users,
        valid_companies: valid_companies
      ).generate_ledger

      Printer.print_to_file(DATA_FILES_INFO[:output_filename], ledger)
      Printer.print_to_stdout(ledger)
    end

    private

    def transactions
      @transactions ||= TransactionGenerator.new(
        users: active_users, companies: valid_companies
      ).perform
    end

    def valid_users
      @valid_users = User::UserRecords.new(@users_filename).users
    end

    def valid_companies
      @valid_companies = Company::CompanyRecords.new(@companies_filename).companies
    end

    def active_users
      @active ||= valid_users.select do |key, user|
        user.active? && valid_companies[user.company_id]
      end
    end

    def notify_users
      transactions.transform_values do |transaction_list|
        emailed = []
        not_emailed = []
        transaction_list.each do |transaction|
          if send_email?(transaction.company_id, transaction.user_id)
            emailed << transaction
          else
            not_emailed << transaction
          end
        end
        {
          emailed: emailed,
          not_emailed: not_emailed
        }
      end
    end

    def send_email?(company_id, user_id)
      puts "ID #{user_id}"
      puts "COMPany ID #{company_id}"
      valid_companies[company_id].email_status && active_users[user_id].notify?
    end

    def get_data_path(file_name)
      File.join(Dir.pwd, DATA_FILES_INFO[:file_directory], file_name)
    end
  end
end
