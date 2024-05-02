class ApplicationController < ActionController::API
	respond_to :json
	include ActionController::MimeResponds
	rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
	before_action :configure_permitted_parameters, if: :devise_controller?

	private

	def record_not_found(exception)
		render json: { error: "Record not found" }, status: :not_found
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: %i[username])
		update_attrs = %i[password password_confirmation current_password]
		devise_parameter_sanitizer.permit(:account_update, keys: update_attrs)
	end
end
