# frozen_string_literal: true
require 'json'

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
      @data = parser.parse(json_data)
    end
    @data
  end

  private :file_name, :parser
end

