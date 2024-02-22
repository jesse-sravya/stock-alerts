class ApplicationController < ActionController::API
    include JwtToken
    before_action :authenticate_user

    private
        def authenticate_user
            header = request.headers['Authorization']
            header = header.split(" ").last if header
            begin
                decoded = jwt_decode(header)
                @current_user = User.find(decoded[:user_id])
            rescue ActiveRecord::RecordNotFound => error
                render json: { errors: error.message }, status: :unauthorized
            rescue JWT::DecodeError => error
                render json: { errors: error.message }, status: :unauthorized
            end
        end

        def authenticate_admin
            if @current_user&.role != "admin"
                render json: { error: "Access Denied" }, status: :unauthorized
            end
        end
end
