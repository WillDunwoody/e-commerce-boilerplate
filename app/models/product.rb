class Product < ApplicationRecord
	validates :name, presence: { message: "name can't be blank" }
	validates :description, presence: { message: "description can't be blank" }
	validates :price, numericality: { greater_than: 0, message: "Price must be greater than zero" }
end
