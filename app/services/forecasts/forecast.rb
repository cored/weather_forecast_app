module Forecasts
  InvalidForecast = Class.new(StandardError)

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
      raise InvalidForecast if response.data.keys.size < 8
      new(response.data.merge(address: address))
    end

    def formatted_address
      address.formatted
    end
  end
end
