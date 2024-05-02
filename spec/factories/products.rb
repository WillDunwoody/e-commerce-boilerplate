FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { 'Lorem ipsum dolor sit amet' }
    price { 10.00 }
    stock_quantity { 100 }
  end
end
