class ApplicationController < ActionController::API
	respond_to :json

	include Pundit::Authorization
	include ActionController::MimeResponds

	before_action :configure_permitted_parameters, if: :devise_controller?

	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	private

	def user_not_authorized(_exception)
		render json: { error: "Unauthorized to perform this action." }, status: :forbidden
	end

	def record_not_found(_exception)
		render json: { error: "Record not found" }, status: :not_found
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
		update_attrs = %i[password password_confirmation current_password]
		devise_parameter_sanitizer.permit(:account_update, keys: update_attrs)
	end
end
