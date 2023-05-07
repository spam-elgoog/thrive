# frozen_string_literal: true

require_relative "base"

module DTO
  class User < DTO::Base
    attributes :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens

    def notify?
      email_status
    end

    def active?
      active_status
    end
  end
end
