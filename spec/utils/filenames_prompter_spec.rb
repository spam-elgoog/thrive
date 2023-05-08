require_relative "../../lib/utils/filenames_prompter"

require "tempfile"
require "json"

RSpec.describe FilenamesPrompter do
  describe ".prompt_users_filename" do
    context "when given an existing valid JSON file" do
      it "returns the file name" do
        with_valid_tempfile do |valid_tempfile_path|
          expect($stdout).not_to receive(:puts)
          result = described_class.prompt_users_filename(valid_tempfile_path)
          expect(result).to eq(valid_tempfile_path)
        end
      end
    end

    context "when given a non-existing file" do
      it "prompts the user until a valid file is provided" do
        with_valid_tempfile do |valid_tempfile_path|
          non_existent_file = "/data/fake.json"
          allow($stdin).to receive(:gets).and_return(non_existent_file, "")
          allow($stdin).to receive(:gets).and_return(valid_tempfile_path, "")
          expect {
            result = described_class.prompt_users_filename(non_existent_file)
            expect(result).to eq(valid_tempfile_path)
          }.to output(/WARN - File #{non_existent_file} does not exist/).to_stdout
        end
      end
    end

    context "when given an invalid extension file" do
      it "prompts the user until a valid JSON file with .json extension is provided" do
        with_valid_tempfile do |valid_tempfile_path|
          Tempfile.create(%w[users .txt]) do |invalid_tempfile|
            allow($stdin).to receive(:gets).and_return(invalid_tempfile.path, "")
            allow($stdin).to receive(:gets).and_return(valid_tempfile_path, "")
            expect {
              result = described_class.prompt_users_filename(invalid_tempfile.path)
              expect(result).to eq(valid_tempfile_path)
            }.to output(/WARN - File must have a .json extension/).to_stdout
          end
        end
      end
    end
  end

  describe ".prompt_companies_filename" do
    context "when given an existing valid JSON file" do
      it "returns the file name" do
        with_valid_tempfile("companies") do |valid_tempfile_path|
          expect($stdout).not_to receive(:puts)
          result = described_class.prompt_companies_filename(valid_tempfile_path)
          expect(result).to eq(valid_tempfile_path)
        end
      end
    end

    describe ".valid_filename?" do
      context "when the file exists and has a .json extension and contains valid JSON" do
        it "returns true" do
          with_valid_tempfile do |valid_json_file|
            expect(FilenamesPrompter.send(:valid_filename?, valid_json_file)).to eq(true)
          end
        end
      end

      context "when the file does not exist" do
        it "returns false" do
          expect(FilenamesPrompter.send(:valid_filename?, "non_existent_file.json")).to eq(false)
        end
      end

      context "when the file has an extension other than .json" do
        it "returns false" do
          with_invalid_extension_tempfile do |invalid_extension_file|
            expect(FilenamesPrompter.send(:valid_filename?, invalid_extension_file)).to eq(false)
          end
        end
      end

      context "when the file exists and has a .json extension but does not contain valid JSON" do
        it "returns false" do
          with_valid_tempfile(nil, "boom") do |invalid_content|
            expect(FilenamesPrompter.send(:valid_filename?, "invalid_users.json")).to eq(false)
          end
        end
      end
    end
    # Rest of tests are similar
  end

  def with_valid_tempfile(type = "users", content = {})
    Tempfile.create(%w[type .json]) do |tempfile|
      tempfile.write content.to_s
      tempfile.rewind
      yield tempfile.path.downcase
    end
  end

  def with_invalid_extension_tempfile
    Tempfile.create(%w[type .txt]) do |tempfile|
      tempfile.write "{}"
      tempfile.rewind
      yield tempfile.path.downcase
    end
  end
end

# RSpec.describe FilenamesPrompter do
#   describe ".prompt_users_filename" do
#     context "when the input file is valid" do
#       let(:valid_file) { Tempfile.new(["users", ".json"]) }

#       it "returns the input file name" do
#         expect(described_class.prompt_users_filename(valid_file.path)).to eq(valid_file.path)
#       end
#     end

#     context "when the input file is invalid" do
#       let(:invalid_file) { Tempfile.new(["users", ".txt"]) }

#       it "prompts the user for a valid file name" do
#         allow($stdout).to receive(:puts).with("Cannot find users file #{invalid_file.path}")
#         allow($stdout).to receive(:puts).with("Please enter a valid JSON format filename for users: ").and_return("new_users.json")
#         expect(described_class.prompt_users_filename(invalid_file.path)).to eq("new_users.json")
#       end
#     end

#     context "when the input file is invalid JSON format" do
#       let(:invalid_json_file) { Tempfile.new(["users", ".json"]) }

#       before do
#         invalid_json_file.write("invalid_json")
#         invalid_json_file.rewind
#       end

#       it "prompts the user for a valid file name" do
#         allow($stdout).to receive(:puts).with("Cannot find users file #{invalid_json_file.path}")
#         allow($stdout).to receive(:puts).with("Please enter a valid JSON format filename for users: ").and_return("new_users.json")
#         expect(described_class.prompt_users_filename(invalid_json_file.path)).to eq("new_users.json")
#       end
#     end
#   end

#   describe ".prompt_companies_filename" do
#     context "when the input file is valid" do
#       let(:valid_file) { Tempfile.new(["companies", ".json"]) }

#       it "returns the input file name" do
#         expect(described_class.prompt_companies_filename(valid_file.path)).to eq(valid_file.path)
#       end
#     end

#     context "when the input file is invalid" do
#       let(:invalid_file) { Tempfile.new(["companies", ".txt"]) }

#       it "prompts the user for a valid file name" do
#         allow($stdout).to receive(:puts).with("Cannot find companies file #{invalid_file.path}")
#         allow($stdout).to receive(:puts).with("Please enter a valid JSON format filename for companies: ").and_return("new_companies.json")
#         expect(described_class.prompt_companies_filename(invalid_file.path)).to eq("new_companies.json")
#       end
#     end

#     context "when the input file is invalid JSON format" do
#       let(:invalid_json_file) { Tempfile.new(["companies", ".json"]) }

#       before do
#         invalid_json_file.write("invalid_json")
#         invalid_json_file.rewind
#       end

#       it "prompts the user for a valid file name" do
#         allow($stdout).to receive(:puts).with("Cannot find companies file #{invalid_json_file.path}")
#         allow($stdout).to receive(:puts).with("Please enter a valid JSON format filename for companies: ").and_return("new_companies.json")
#         expect(described_class.prompt_companies_filename(invalid_json_file.path)).to eq("new_companies.json")
#       end
#     end
#   end
# end

# RSpec.describe FilenamesPrompter do
#   describe ".valid_filename?" do
#     context "when the file exists and has a .json extension and contains valid JSON" do
#       it "returns true" do
#         expect(FilenamesPrompter.send(:valid_filename?, "valid_users.json")).to eq(true)
#       end
#     end

#     context "when the file does not exist" do
#       it "returns false" do
#         expect(FilenamesPrompter.send(:valid_filename?, "non_existent_file.json")).to eq(false)
#       end
#     end

#     context "when the file has an extension other than .json" do
#       it "returns false" do
#         expect(FilenamesPrompter.send(:valid_filename?, "non_json.txt")).to eq(false)
#       end
#     end

#     context "when the file exists and has a .json extension but does not contain valid JSON" do
#       it "returns false" do
#         expect(FilenamesPrompter.send(:valid_filename?, "invalid_users.json")).to eq(false)
#       end
#     end
#   end

#   describe ".prompt_users_filename" do
#     context "when the given filename is valid" do
#       it "returns the filename" do
#         expect(FilenamesPrompter.prompt_users_filename("valid_users.json")).to eq("valid_users.json")
#       end
#     end

#     context "when the given filename is not valid" do
#       it "prompts the user for a valid filename and returns it" do
#         allow($stdin).to receive(:gets).and_return("invalid_users.json", "valid_users.json")
#         expect($stdout).to receive(:puts).with("Cannot find users file invalid_users.json")
#         expect($stdout).to receive(:puts).with("Please enter a valid JSON format filename for users: ")
#         expect($stdout).to receive(:puts).with("Cannot find users file invalid_users.json")
#         expect($stdout).to receive(:puts).with("Please enter a valid JSON format filename for users: ")
#         expect(FilenamesPrompter.prompt_users_filename("invalid_users.json")).to eq("valid_users.json")
#       end
#     end
#   end

#   describe ".prompt_companies_filename" do
#     context "when the given filename is valid" do
#       it "returns the filename" do
#         expect(FilenamesPrompter.prompt_companies_filename("valid_companies.json")).to eq("valid_companies.json")
#       end
#     end

#     context "when the given filename is not valid" do
#       it "prompts the user for a valid filename and returns it" do
#         allow($stdin).to receive(:gets).and_return("invalid_companies.json", "valid_companies.json")
#         expect($stdout).to receive(:puts).with("Cannot find companies file invalid_companies.json")
#         expect($stdout).to receive(:puts).with("Please enter a valid JSON format filename for companies: ")
#         expect($stdout).to receive(:puts).with("Cannot find companies file invalid_companies.json")
#         expect($stdout).to receive(:puts).with("Please enter a valid JSON format filename for companies: ")
#         expect(FilenamesPrompter.prompt_companies_filename("invalid_companies.json")).to eq("valid_companies.json")
#       end
#     end
#   end
# end
