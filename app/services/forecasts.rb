module Forecasts
  extend self

  def by_address(address, store, weather_api=OpenWeatherMap)
    forecast = Forecast.of(
      weather_api.forecast_by_address(address),
      address
    )

    store.write(address.formatted, forecast, expires_in: ENV.fetch('CACHE_EXPIRES_IN', 30.minutes))

    forecast
  end
end
