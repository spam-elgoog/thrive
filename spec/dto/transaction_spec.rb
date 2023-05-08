require_relative "../../lib/dto/transaction"

RSpec.describe DTO::Transaction do
  let(:transaction) do
    described_class.new(
      company_id: 1,
      user_id: 1,
      previous_balance: 100,
      top_up: 50,
      processed_at: processed_at
    )
  end
  let(:processed_at) { Time.new(2023, 5, 8, 12, 0, 0) }

  describe "#initialize" do
    it "sets the company_id attribute" do
      expect(transaction.company_id).to eq(1)
    end

    it "sets the user_id attribute" do
      expect(transaction.user_id).to eq(1)
    end

    it "sets the previous_balance attribute" do
      expect(transaction.previous_balance).to eq(100)
    end

    it "sets the top_up attribute" do
      expect(transaction.top_up).to eq(50)
    end

    it "sets the processed_at attribute" do
      expect(transaction.processed_at).to eq(processed_at)
    end
  end

  describe "#<=>" do
    it "compares transactions by company_id" do
      transaction1 = described_class.new(company_id: 1)
      transaction2 = described_class.new(company_id: 2)
      transaction3 = described_class.new(company_id: 3)

      expect(transaction1 <=> transaction2).to eq(-1)
      expect(transaction2 <=> transaction1).to eq(1)
      expect(transaction2 <=> transaction3).to eq(-1)
      expect(transaction3 <=> transaction2).to eq(1)
      expect(transaction1 <=> transaction1).to eq(0) # standard:disable Lint/BinaryOperatorWithIdenticalOperands
    end
  end
end
