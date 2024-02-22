class AlertsController < ApplicationController
    before_action :authenticate_admin, only: [:all]

    def index
        @alerts = @current_user.alerts
        render json: @alerts, status: 200
    end

    def all
        render json: Alert.all, status: 200
    end
end
