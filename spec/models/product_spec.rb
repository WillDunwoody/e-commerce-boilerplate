require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    let(:valid_attributes) { { name: 'Phone 1', description: 'Lorem ipsum', price: 10, stock_quantity: 1 } }

    it 'is valid with valid attributes' do
      product = Product.new(valid_attributes)

      expect(product).to be_valid
    end

    it 'is not valid without a name' do
      product = Product.new(valid_attributes.merge(name: nil))

      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("name can't be blank")
    end

    it 'is not valid without a description' do
      product = Product.new(valid_attributes.merge(description: nil))

      expect(product).not_to be_valid
      expect(product.errors[:description]).to include("description can't be blank")
    end

    it 'is not valid if price is zero' do
      product = Product.new(valid_attributes.merge(price: 0))

      expect(product).not_to be_valid
      expect(product.errors[:price]).to include("Price must be greater than zero")
    end
  end
end
