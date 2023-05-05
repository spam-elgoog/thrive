require 'rspec'
require 'file_loader'
require 'tempfile'

RSpec.describe FileLoader do
  let(:json_data) { '{"foo": "bar"}' }
  let(:temp_file) do
    file = Tempfile.new('test.json')
    file.write(json_data)
    file.rewind
    file
  end

  describe '#load_data' do
    it 'loads JSON data from a file' do
      loader = FileLoader.new(temp_file.path)
      expect(loader.load_data).to eq({ 'foo' => 'bar' })
    end

    it 'uses a custom parser if provided' do
      parser = double(:parser, parse: { 'baz' => 'qux' })
      loader = FileLoader.new(temp_file.path, parser)
      expect(loader.load_data).to eq({ 'baz' => 'qux' })
    end
  end
end