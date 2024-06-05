require 'rails_helper'

RSpec.describe OpenWeatherMap do
  subject(:open_weather_map) { described_class.new(api_client: api_client) }
  let(:api_client) { instance_double(OpenWeather::Client, current_weather: api_client_response) }

  describe '#forecast_by_address' do
    let(:api_client_response) { double('api_client_response', main: { city: 'London' }) }
    let(:address) { instance_double(Forecasts::Address, city: 'London') }

    it 'returns a forecast for a given address' do
      open_weather_map.forecast_by_address(address)

      expect(api_client).to have_received(:current_weather).with({ city: 'London'})
    end
  end
end
