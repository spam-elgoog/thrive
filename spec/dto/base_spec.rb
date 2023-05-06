# frozen_string_literal: true
require 'dto/base'

RSpec.describe DTO::Base do
  describe '.attributes' do
    context 'when given attribute names' do
      let(:klass) do
        Class.new(DTO::Base) do
          attributes :name, :age, :gender
        end
      end

      it 'defines the attributes as read-only' do
        person = klass.new(name: "John", age: 30, gender: "Male")
        expect(person.name).to eq "John"
        expect(person.age).to eq 30
        expect(person.gender).to eq "Male"

        expect{ person.name = "Jane" }.to raise_error(NoMethodError)
      end

      it 'creates an initializer that takes named parameters' do
        expect(klass.instance_method(:initialize).parameters).to eq [[:keyrest, :kwargs]]
      end
    end
  end
end
