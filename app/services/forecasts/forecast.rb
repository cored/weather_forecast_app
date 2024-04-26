module Forecasts

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
end
