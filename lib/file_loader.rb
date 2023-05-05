# frozen_string_literal: true
require 'json'

class FileLoader
  attr_reader :file_name, :parser

  def initialize(file_name, parser = JSON)
    @file_name = file_name
    @parser = parser
  end

  def load_data
    json_data = File.read(file_name)
    parser.parse(json_data)
  end

  private :file_name, :parser
end

