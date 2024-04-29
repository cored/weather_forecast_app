require 'rails_helper'

RSpec.describe Forecasts do
  subject(:forecasts) { described_class }
  let(:store) { double(:rails_cache, write: nil) }
  let(:weather_api) { instance_double(OpenWeatherMap, forecast_by_address: response) }

  describe '.by_address' do
    context 'when the address is valid' do
      let(:forecast_attrs) do
        { temp: 100,
          feels_like: 100,
          temp_min: 100,
          temp_max: 100,
          humidity: 100,
          grnd_level: 100,
          sea_level: 100,
          pressure: 100,
          address: Forecasts::Address.of('Calle 13, Bogota, Cundinamarca, 110111, Colombia') }
      end
      let(:response) do
        instance_double(OpenWeatherMap::Response, data: forecast_attrs)
      end
      let(:forecast) { Forecasts::Forecast.new(forecast_attrs) }

      it 'returns a forecast' do
        expect(
          forecasts.by_address(
            'Calle 13, Bogota, Cundinamarca, 110111, Colombia',
            store,
            weather_api,
          ).formatted_address
        ).to eql('Calle 13, Bogota, Cundinamarca, 110111, Colombia')
      end

      it 'caches the forecast' do
        forecasts.by_address(
          'Calle 13, Bogota, Cundinamarca, 110111, Colombia',
          store,
          weather_api,
        )

        expect(store).to have_received(:write).with(
          'Calle 13, Bogota, Cundinamarca, 110111, Colombia',
          forecast,
          expires_in: 30.minutes,
        )
      end
    end
  end
end
