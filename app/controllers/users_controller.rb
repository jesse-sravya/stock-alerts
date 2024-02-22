class UsersController < ApplicationController
    skip_before_action :authenticate_user, only: [:create]
    before_action :find_user, only: [:show, :update, :destroy]
    before_action :authenticate_admin, only: [:index, :destroy]
    before_action :paginate, only: [:index]

    def index
        @users = User.all.order(:created_at).limit(@page_limit).offset(@page_offset)
        render json: @users, status: 200
    end

    def show
        render json: @user, :only => User::VIEWABLE_ATTRIBUTES, status: 200
    end

    def create
        @user = User.new(user_params)
        if @user.save
            render json: @user, status: 200
        else
            render json: { errors: @user.errors.full_messages }, status: 503
        end
    end

    def update
        unless @user.update(user_params)
            render json: { errors: @user.errors.full_messages}, status: 503
        end
    end

    def destroy
        if @user.destroy
            render json: { message: "Deleted successfully" }, status: 204
        end
    end

    # TODO: add forgot_password flow

    private
        def user_params
            params.permit(:name, :email, :password)
        end

        def find_user
            @user = User.where(id: params[:id]).first
            unless @user
                render json: { error: "User Not Found" }, status: :not_found
            end
        end
end
