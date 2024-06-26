require 'open-weather-ruby-client'

class OpenWeatherMap
  def self.forecast_by_address(address, api_key=ENV['OPEN_WEATHER_API_KEY'])
    api_client = OpenWeather::Client.new(api_key: api_key)
    new(api_client: api_client).forecast_by_address(address)
  end

  def initialize(api_client:)
    @api_client = api_client
  end

  Response = Struct.new(:data, keyword_init: true) do
    def self.of(data)
      new(data: data.main.to_h)
    end
  end
  def forecast_by_address(address)
    Response.of(api_client.current_weather(city: address.city))
  end

  private

  attr_reader :api_client
end
