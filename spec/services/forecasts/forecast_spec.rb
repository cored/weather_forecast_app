require 'rails_helper'

RSpec.describe Forecasts::Forecast do
  subject(:forecast) { described_class }

  describe '.of' do
    context 'when the forecast is empty' do
      let(:response) { instance_double(OpenWeatherMap::Response, data: {}) }
      let(:address) { instance_double(Forecasts::Address) }

      it 'throws an invalid forecast error' do
        expect { forecast.of(response, address) }.to raise_error(Forecasts::InvalidForecast)
      end
    end

    context 'when some forecast data is present' do
      let(:response) do
        instance_double(OpenWeatherMap::Response,
                        data: { temp: 100 })
      end
      let(:address) { instance_double(Forecasts::Address) }

      it 'throws an invalid forecast error' do
        expect { forecast.of(response, address) }.to raise_error(Forecasts::InvalidForecast)
      end

    end

  end

end
