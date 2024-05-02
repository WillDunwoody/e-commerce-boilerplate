class Api::V1::Admin::ProductsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_product, only: [:show, :update, :destroy]

	def create
		product = Product.new(create_product_params)

		if product.save
			render json: product, status: :created
		else
			render json: product.errors, status: :unprocessable_entity
		end
	end

	def update
		if @product.update(update_product_params)
			render json: @product, status: :ok
		else
			render json: @product.errors, status: :unprocessable_entity
		end
	end

	def show
		render json: @product, status: :ok
	end

	def destroy
		@product.destroy
		render json: { message: 'Product successfully deleted' }, status: :ok
	end

	private

	def set_product
		@product = Product.find(params[:id])
	end

	def create_product_params
		params.require(:product).permit(:name, :description, :price, :stock_quantity)
	end

	def update_product_params
		params.require(:product).permit(:name, :description, :price, :stock_quantity)
	end
end
