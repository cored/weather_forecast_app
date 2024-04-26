module Forecasts
  extend self

  def by_address(address, store, weather_api=OpenWeatherMap)
    forecast_address = Address.of(address)

    forecast = Forecast.of(
      weather_api.forecast_by_address(forecast_address),
      forecast_address
    )

    store.write(forecast_address.formatted, forecast, expires_in: ENV.fetch('CACHE_EXPIRES_IN', 30.minutes))

    forecast
  end
end
