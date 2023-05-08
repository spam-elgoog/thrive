# frozen_string_literal: true

class Printer
  def self.print_to_file(file_name, ledger)
    file_path = FileCreator.create_file(file_name)
    File.open(file_path, "w") do |file|
      file.puts ledger
    end
  end

  def self.print_to_stdout(ledger)
    # prints to stdout
    print ledger
  end
end
