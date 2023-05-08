class FilenamesPrompter
  class << self
    def prompt_users_filename(users_filename)
      return users_filename if valid_filename?(users_filename)
      prompt("users", users_filename)
    end

    def prompt_companies_filename(companies_filename)
      return companies_filename if valid_filename?(companies_filename)
      prompt("companies", companies_filename)
    end

    private

    def prompt(type, file_name)
      loop do
        $stdout.puts "The #{type} file '#{file_name}' didnt pass validation. Make sure it has .json extension and has valid json format."
        $stdout.puts "Please enter a valid JSON format filename for #{type}: "
        file_name = $stdin.gets.strip.downcase
        return file_name if valid_filename?(file_name)
      end
    end

    def valid_filename?(filename)
      if filename.nil? || filename == ""
        $stdout.puts "File name cannot be nil or blank"
        return false
      elsif !filename.end_with?(".json")
        $stdout.puts "File must have a .json extension"
        return false
      elsif !File.exist?(filename)
        $stdout.puts "File #{filename} does not exist"
        return false
      elsif !valid_json?(filename)
        $stdout.puts "File #{filename} does not contain valid JSON"
        return false
      end

      true
    end

    def valid_json?(filename)
      JSON.parse(File.read(filename))
      true
    rescue JSON::ParserError => e
      puts e
      false
    end
  end
end
