# frozen_string_literal: true

require "dto/user"

RSpec.describe DTO::User do
  describe ".attributes" do
    context "when given attribute names" do
      it "defines the attributes as read-only" do
        user = described_class.new(id: 1, first_name: "John", last_name: "Doe", email: "john.doe@example.com", company_id: 1, email_status: true, active_status: true, tokens: 10)

        expect(user.id).to eq 1
        expect(user.first_name).to eq "John"
        expect(user.last_name).to eq "Doe"
        expect(user.email).to eq "john.doe@example.com"
        expect(user.company_id).to eq 1
        expect(user.email_status).to eq true
        expect(user.active_status).to eq true
        expect(user.tokens).to eq 10

        expect { user.id = 2 }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#notify?" do
    context "when email status is true" do
      it "returns true" do
        user = described_class.new(id: 1, first_name: "John", last_name: "Doe", email: "john.doe@example.com", company_id: 1, email_status: true, active_status: true, tokens: 10)
        expect(user.notify?).to eq true
      end
    end

    context "when email status is false" do
      it "returns false" do
        user = described_class.new(id: 1, first_name: "John", last_name: "Doe", email: "john.doe@example.com", company_id: 1, email_status: false, active_status: true, tokens: 10)
        expect(user.notify?).to eq false
      end
    end
  end

  describe "#active?" do
    context "when active status is true" do
      it "returns true" do
        user = described_class.new(id: 1, first_name: "John", last_name: "Doe", email: "john.doe@example.com", company_id: 1, email_status: true, active_status: true, tokens: 10)
        expect(user.active?).to eq true
      end
    end

    context "when active status is false" do
      it "returns false" do
        user = described_class.new(id: 1, first_name: "John", last_name: "Doe", email: "john.doe@example.com", company_id: 1, email_status: false, active_status: false, tokens: 10)
        expect(user.active?).to eq false
      end
    end
  end

  describe "#<=>" do
    let(:user_attrs) do
      {
        id: 1,
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        company_id: 1,
        email_status: true,
        active_status: true,
        tokens: 100
      }
    end

    it "sorts users by last name and first name" do
      user1 = described_class.new(**user_attrs.merge(first_name: "John", last_name: "Doe"))
      user2 = described_class.new(**user_attrs.merge(first_name: "Jane", last_name: "Doe"))
      user3 = described_class.new(**user_attrs.merge(first_name: "John", last_name: "Smith"))

      expect([user1, user2, user3].sort).to eq([user2, user1, user3])
    end
  end
end
