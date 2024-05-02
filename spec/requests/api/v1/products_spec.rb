require 'rails_helper'

RSpec.describe 'Api::V1::ProductsController', type: :request do
	describe 'GET /api/v1/products' do
		let!(:products) { create_list(:product, 10) }

		it 'returns all products' do
			get api_v1_products_path

			expect(response).to have_http_status(:success)
			expect(JSON.parse(response.body).size).to eq(10)
		end
	end

	describe 'GET /api/v1/products/:id' do
		let!(:product) { create(:product) }

		it 'returns a product' do
			get "/api/v1/products/#{product.id}"

			expect(response).to have_http_status(:success)
			json_response = JSON.parse(response.body)
			expect(json_response['id']).to eq(product.id)
		end
	end
end
