# frozen_string_literal: true

module DTO
  class Company < Base
    attributes :id, :name, :top_up, :email_status

    def send_email_notification?
      email_status
    end
  end
end
