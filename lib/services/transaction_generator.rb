# frozen_string_literal: true

# Crates a hash of transactions that represents all the active users
# that whose balance of tokens will be updated. Transactions are grouped by
# the company id. Transactions are unsorted.
# {
#   3: [
#     <DTO::Transaction:0x00000001d5a5c5a0 @company_id=3, @user_id=4, ....>,
#     <DTO::Transaction:0x00000001d5a5c5a0 @company_id=3, @user_id=2, ....>
#   ],
#   1: [
#     <DTO::Transaction:0x00000001d5a5c5a0 @company_id=1, @user_id=1, ....>,
#     <DTO::Transaction:0x00000001d5a5c5a0 @company_id=1, @user_id=3, ....>
#   ]
# }
#
# @param users [Array<DTO::User>] list of users
# @param companies [Hash<Integer, DTO::Company>]
# @return [Hash<Integer, DTO::Transaction>]
module Services
  class TransactionGenerator
    # users: Array
    # companies: Hash
    def initialize(users:, companies:)
      @users = users || {}
      @companies = companies || {}
    end

    def perform
      process
    end

    private

    def process
      transactions_by_company = {}
      @users.each_pair do |user_id, user|
        company = @companies[user.company_id]
        unless company
          ## TODO: create standard result object
          puts "Company does not exist #{user.company_id}"
          next
        end
        processed_transactions_array = transactions_by_company.fetch(company.id, [])
        transactions_by_company[company.id] = processed_transactions_array << create_transaction(user, company)
      end
      transactions_by_company
    end

    def create_transaction(user, company)
      DTO::Transaction.new(
        company_id: company.id,
        user_id: user.id,
        previous_balance: user.tokens,
        top_up: company.top_up,
        processed_at: Time.now
      )
    end
  end
end
