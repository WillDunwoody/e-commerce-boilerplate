require 'rails_helper'

RSpec.describe 'Api::V1::Admin::ProductsController', type: :request do
	describe 'As non admin' do
		let(:non_admin) { create(:user, admin: false) }  # Assuming you have some way to authenticate
		let(:token) { Warden::JWTAuth::UserEncoder.new.call(non_admin, :user, nil) }
		let(:auth_headers) { { 'Authorization' => "Bearer #{token.first}" } }

		describe 'POST /api/v1/admin/products' do
			let(:product_params) { { product: { name: 'New Phone', price: 500, description: 'Lorem ipsum' } } }

			it 'does not allow creating a product' do
				expect {
					post '/api/v1/admin/products', params: product_params, headers: auth_headers
				}.not_to change(Product, :count)


				expect(response).to have_http_status(:forbidden)
			end
		end

		describe 'GET /api/v1/admin/products/:id' do
			let!(:product) { create(:product) }

			it 'does not allow viewing a product' do
				get "/api/v1/admin/products/#{product.id}", headers: auth_headers
				expect(response).to have_http_status(:forbidden)
			end
		end

		describe 'PUT /api/v1/admin/products/:id' do
			let!(:product) { create(:product) }
			let(:product_params) { { product: { name: "Updated Phone" } } }

			it 'does not allow updating a product' do
				put "/api/v1/admin/products/#{product.id}", params: { product: product_params }, headers: auth_headers
				expect(response).to have_http_status(:forbidden)
			end
		end

		describe 'DELETE /api/v1/admin/products/:id' do
			let!(:product) { create(:product) }

			it 'does not allow deleting a product' do
				expect {
					delete "/api/v1/admin/products/#{product.id}", headers: auth_headers
				}.not_to change(Product, :count)
				expect(response).to have_http_status(:forbidden)
			end
		end
	end

	describe 'As admin' do
		let(:admin) { create(:user, admin: true) }  # Assuming you have some way to authenticate
		let(:token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil) }
		let(:auth_headers) { { 'Authorization' => "Bearer #{token.first}" } }

		describe 'POST /api/v1/admin/products' do
			let(:product_params) { { product: { name: 'New Phone', price: 500, description: 'Lorem ipsum' } } }

			context 'when the product has required fields' do
				it 'creates a new product' do
					expect {
						post '/api/v1/admin/products', params: product_params, headers: auth_headers
					}.to change(Product, :count).by(1)

					expect(response).to have_http_status(:created)
				end
			end

			context 'when the product has missing required fields' do
				let(:invalid_product_params) { { product: { name: 'Incomplete Phone', price: 200.0 } } }  # Missing description and price

				it 'does not create a product' do
					expect {
						post '/api/v1/admin/products', params: invalid_product_params, headers: auth_headers
					}.not_to change(Product, :count)

					expect(response).to have_http_status(:unprocessable_entity)
					expect(JSON.parse(response.body)).to include("description" => ["description can't be blank"])
				end
			end
		end

		describe 'GET /api/v1/admin/products/:id' do
			let!(:product) { create(:product) }

			it 'returns a product' do
				get "/api/v1/admin/products/#{product.id}",  headers: auth_headers

				expect(response).to have_http_status(:success)
				json_response = JSON.parse(response.body)
				expect(json_response['id']).to eq(product.id)
			end
		end

		describe 'PUT /api/v1/admin/products/:id' do
			let!(:product) { create(:product) }

			context 'when the product has required fields' do
				it 'updates a product' do
					new_name = "Updated Phone"
					put "/api/v1/admin/products/#{product.id}", params: { product: { name: new_name } }, headers: auth_headers

					expect(response).to have_http_status(:ok)
					expect(product.reload.name).to eq(new_name)
				end
			end

			context 'when the product has missing required fields' do
				it 'updates a product' do
					put "/api/v1/admin/products/#{product.id}", params: { product: { name: nil } }, headers: auth_headers

					expect(response).to have_http_status(:unprocessable_entity)
					expect(JSON.parse(response.body)).to include("name" => ["name can't be blank"])
				end
			end

			context 'when the product is not found' do
				it 'returns an error' do
					put "/api/v1/admin/products/0", params: { product: { name: nil } }, headers: auth_headers

					expect(response).to have_http_status(:not_found)
					expect(JSON.parse(response.body)).to include("error" => "Record not found")
				end
			end
		end

		describe 'DELETE /api/v1/admin/products/:id' do
			let!(:product) { create(:product) }

			it 'deletes a product' do
				expect {
					delete "/api/v1/admin/products/#{product.id}", headers: auth_headers
				}.to change(Product, :count).by(-1)

				expect(response).to have_http_status(:ok)
			end
		end
	end
end
