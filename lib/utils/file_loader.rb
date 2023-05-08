# frozen_string_literal: true

require "json"

class FileLoader
  attr_reader :file_name, :parser

  def initialize(file_name, parser = JSON)
    unless File.exist?(file_name)
      raise "File not found: #{file_name}"
    end
    @file_name = file_name
    @parser = parser
  end

  def load_data
    unless defined? @data
      json_data = File.read(file_name)
      begin
        @data = parser.parse(json_data, symbolize_names: true)
      rescue JSON::ParserError => e
        puts "FileLoader::Parsing error for #{file_name}, fix the file and try again."
        puts "Check the `logs.log` file in root for details."
        raise e
      end
    end
    @data
  end

  private :file_name, :parser
end
