# frozen_string_literal: true

# If not already exists, creates a file in a folder named `output`.
# The output folder is created in the root of the project.
#
class FileCreator
  def self.create_file(filename)
    output_dir = File.join(Dir.pwd, "output")
    Dir.mkdir(output_dir) unless Dir.exist?(output_dir)

    file_path = File.join(output_dir, filename)
    File.new(file_path, "w")
  end
end
