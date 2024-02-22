class ApplicationController < ActionController::API
    include JwtToken
    before_action :authenticate_user

    private
        def authenticate_user
            header = request.headers['Authorization']
            header = header.split(" ").last if header
            begin
                decoded = jwt_decode(header)
                @current_user = User.where(id: decoded[:user_id]).first
                unless @current_user
                    render json: { errors: "User token expired!" }, status: :unauthorized
                end
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

        def paginate
            @page_limit = params[:count].to_i
            @page_limit = 10 if not @page_limit or @page_limit <= 0

            @page = params[:page].to_i
            @page = 1 if not @page or @page <= 0
            @page_offset = (@page - 1) * @page_limit + 1
        end
end
