#!/usr/bin/env ruby
# frozen_string_literal: true

require "logger"
require_relative "lib/services/files_processor"

logger = Logger.new("logs.log")
begin
  Services::FilesProcessor.new.process
rescue => e
  logger.error(e)
end
