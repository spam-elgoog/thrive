# frozen_string_literal: true

require_relative "base"

module DTO
  class Company < DTO::Base
    attributes :id, :name, :top_up, :email_status

    def send_email_notification?
      email_status
    end
  end
end
