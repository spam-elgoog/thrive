# frozen_string_literal: true

require_relative "base"

module DTO
  class Transaction < Base
    attributes :company_id, :user_id, :previous_balance, :top_up, :processed_at

    def <=>(other)
      company_id <=> other.company_id
    end
  end
end
