# frozen_string_literal: true
require 'dto/company'

RSpec.describe DTO::Company do
  describe '.attributes' do
    context 'when given attribute names' do
      let(:id) { 1 }
      let(:name) { 'Acme Inc.' }
      let(:top_up) { 100 }
      let(:email_status) { true }

      it 'defines the attributes as read-only' do
        puts "this is my value #{id}"
        company = described_class.new(id: id, name: name , top_up: top_up, email_status: email_status )
        expect(company.id).to eq(id)
        expect(company.name).to eq(name)
        expect(company.top_up).to eq(top_up)
        expect(company.email_status).to eq(email_status)

        expect{ company.id = 2 }.to raise_error(NoMethodError)
      end
    end
  end
end
