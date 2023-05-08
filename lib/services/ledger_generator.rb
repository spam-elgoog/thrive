# frozen_string_literal: true

# Hot mess :()  oops
module Services
  class LedgerGenerator
    def initialize(transactions:, active_users:, valid_companies:)
      @transactions = transactions
      @active_users = active_users
      @valid_companies = valid_companies
    end

    def generate_ledger
      ledger = @transactions.sort.map do |company_id, val|
        users_section = val.transform_values do |transaction_list|
          transaction_list.sort { |a, b|
            @active_users[a.user_id] <=> @active_users[b.user_id]
          }.map do |transaction|
            user = @active_users[transaction.user_id]
            <<~USER
              #{user.last_name}, #{user.first_name}, #{user.email}
                  Previous Token Balance, #{transaction.previous_balance}
                  New Token Balance #{transaction.previous_balance + transaction.top_up}
            USER
          end
        end

        <<~TRANSACTION
          Company Id: #{company_id}
          Company Name: #{@valid_companies[company_id].name}
          Users Emailed: #{"\n  #{users_section[:emailed].join("  ").chop}" if users_section[:emailed].size > 0}
          Users Not Emailed:
            #{users_section[:not_emailed].join("  ").chop}
            Total amount of top ups for #{@valid_companies[company_id].name}: #{
              val[:emailed].sum(&:top_up) + val[:not_emailed].sum(&:top_up)
            }

        TRANSACTION
      end

      ledger.join
    end
  end
end
