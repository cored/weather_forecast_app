class ForecastRequestJob < ApplicationJob
  queue_as :default

  def perform(address)
    forecast = store.fetch(address) do
      Forecasts.by_address(address, store)
    end

    broadcast(forecast)
  end

  def broadcast(forecast)
    Turbo::StreamsChannel.broadcast_replace_to(
      "forecasts",
      target: "forecast-form",
      partial: "forecasts/forecast_details",
      locals: { forecast: forecast }
    )
  end

  def store
    Rails.cache
  end
end
