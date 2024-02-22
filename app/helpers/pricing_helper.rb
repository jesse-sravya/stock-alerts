module PricingHelper
	require 'uri'
	require 'net/http'

    def self.get_current_price_for_coin(coin_id, currency)
		url = "#{Rails.application.secrets.COIN_GECKO_ENDPOINT}/api/v3/coins/#{coin_id}"
        begin
            response = HTTParty.get(url)
            response = JSON.parse(response.body)
            if response["error"]
                return false, response["error"]
            else
                market_data = response["market_data"]["current_price"]
                if market_data.include?(currency)
                    return true, market_data[currency]
                else
                    return false, "currency #{currency} not found"
                end
            end
        rescue Exception => e
            Rails.logger.error e
            return false, "Something went wrong"
        end

    end
end
