require_relative "../lib/services/files_processor"

RSpec.describe "challenge.rb" do
  let(:file_processor_double) { instance_double("Services::FilesProcessor") }

  before do
    allow(Services::FilesProcessor).to receive(:new).and_return(file_processor_double)
    allow(file_processor_double).to receive(:process).and_return(["Test output\n"])
  end

  it "calls process on an instance of FilesProcessor" do
    expect(file_processor_double).to receive(:process)
    load "./challenge.rb"
  end
end
