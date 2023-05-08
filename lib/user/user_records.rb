# frozen_string_literal: true

# returns a Hash of users<user_id, DTO::Company> with ID as the key
module User
  class UserRecords
    def initialize(filename)
      @filename = filename
    end

    def users
      extracted_user_records = FileLoader.new(@filename).load_data
      User::Processor.new(extracted_user_records, User::Validator)
        .perform
    end
  end
end
