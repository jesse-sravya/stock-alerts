namespace :batch do

  desc "Fetches Pricing"
  task fetch_pricing: :environment do
    grouped_alerts = Alert.where(status: Alert::STATUS_CREATED).group_by(&:coin_id)

    # TODO:
    # WARNING: unnecessary loop,
    # test endpoints from coin gecko to get a singular response
    # and avoid multiple api calls
    # 
    # Better solution: stadardise pricing date to single currency in our db, and use market_data api
    grouped_alerts.each do |coin_id, alerts|
      status, response = PricingHelper.get_current_price_for_coin(coin_id)
      alerts.each do |alert|
        current_price = response[alert.currency]

        # TODO:
        #   can be optimised
        #   can be merged into a single if condition with proper math
        if alert.target_price - alert.current_price > 0 # expecting an increment
          if alert.target_price - current_price < 0
            # price has exceeded, send a notification to user
            # TODO: send email
            alert.status = Alert::STATUS_TRIGGERED
            Rails.logger.info "#{alert.user_id}'s targets have been met current_price #{current_price} (target #{alert.target_price})"
          end
        else # expecting an decrement
          if alert.target_price - current_price < 0
            # price has decreased, send a notification to user
            alert.status = Alert::STATUS_TRIGGERED
            Rails.logger.info "#{alert.user_id}'s targets have been met current_price #{current_price} (target #{alert.target_price})"
            # TODO: send email
          end
        end
        alert.save if alert.changed?
      end
    end
  end

end
