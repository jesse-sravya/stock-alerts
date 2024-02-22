class AlertsController < ApplicationController
    before_action :authenticate_admin, only: [:all]
    before_action :paginate, only: [:index, :all]

    def index
        @alerts = @current_user.alerts.order(:created_at).limit(@page_limit).offset(@page_offset)
        render json: paginated_response(@alerts), status: 200
    end

    def all
        if params[:status]
            @alerts = Alert.where(status: params[:status]).order(:created_at).limit(@page_limit).offset(@page_offset)
        else
            @alerts = Alert.all.order(:created_at).limit(@page_limit).offset(@page_offset)
        end
        render json: paginated_response(@alerts), status: 200
    end

    def create
        alert_params = params.permit(:coin_id, :target_price, :currency)
        unless [alert_params[:coin_id], alert_params[:target_price], alert_params[:currency]].all?
            return render json: { errors: "Missing Attributes" }, status: 503
        end

        alert_params[:currency].downcase!
        @alert = Alert.new(alert_params)
        @alert.user = @current_user

        status, response = PricingHelper.get_current_price_for_coin(@alert.coin_id, @alert.currency)
        unless status
            return render json: { errors: [response] }, status: 200
        end
        @alert.current_price = response

        # TODO: add duplicate alert check
        if @alert.save
            render json: @alert, status: 200
        else
            render json: { errors: @alert.errors.full_messages }, status: 503
        end
    end

    def destroy
        @alert = Alert.where(id: params[:id], user_id: @current_user.id, status: Alert::STATUS_CREATED).first

        unless @alert
            return render json: { error: "Alert Not Found" }, status: :not_found
        end
        if @alert.update(:status => Alert::STATUS_DELETED)
            return render json: { message: "Deleted successfully" }, status: 204
        end
        render json: { message: "Failed to delete alert" }, status: 503
    end

    private
        def paginated_response(alerts)
            {
                alerts: alerts,
                meta: {
                    page: @page,
                    count: @page_limit,
                    # TODO: add total pages to meta data
                }
            }
        end
end
