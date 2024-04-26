module Forecasts
  Address = Struct.new(:street, :city, :state, :zipcode, :country, keyword_init: true) do
    def self.of(address)
      street, city, state, zipcode, country = address.split(/,/).map(&:strip).map(&:downcase)
      new(street: street, city: city, state: state, zipcode: zipcode, country: country)
    end

    def formatted
      "#{street}, #{city}, #{state}, #{zipcode}, #{country}"
    end
  end

  Forecast = Struct.new(:temp,
                        :feels_like,
                        :temp_min,
                        :temp_max,
                        :pressure,
                        :humidity,
                        :sea_level,
                        :grnd_level,
                        :address,
                        keyword_init: true) do
    def self.of(response, address)
      new(response.main.to_h.merge(address: address))
    end

    def formatted_address
      address.formatted
    end
  end

  def self.by_address(address, store, weather_api=OpenWeatherMap)
    forecast_address = Address.of(address)

    forecast = Forecast.of(
      weather_api.forecast_by_address(forecast_address),
      forecast_address
    )

    store.write(forecast_address.formatted, forecast, expires_in: ENV.fetch('CACHE_EXPIRES_IN', 30.minutes))

    forecast
  end
end
