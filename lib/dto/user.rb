# frozen_string_literal: true

module DTO
  class User < Base
    attributes :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens

    def notify?
      email_status
    end

    def active?
      active_status
    end
  end
end