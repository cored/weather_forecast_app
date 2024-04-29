class ForecastRequestJob < ApplicationJob
  queue_as :default

  def perform(address)
    lookup_address = Forecasts::Address.of(address)
    forecast = store.fetch(lookup_address.formatted) do
      Forecasts.by_address(lookup_address, store)
    end

    broadcast_success(forecast)

  rescue Forecasts::InvalidAddress => e
    broadcast_error(e)
  end

  private

  def broadcast_success(forecast)
    Turbo::StreamsChannel.broadcast_replace_to(
      "forecasts",
      target: "forecast-form",
      partial: "forecasts/forecast_details",
      locals: { forecast: forecast }
    )
  end

  def broadcast_error(error)
    Turbo::StreamsChannel.broadcast_replace_to(
      "forecasts",
      target: "forecast-form",
      partial: "forecasts/forecast_error",
      locals: { error: error.message }
    )
  end

  def store
    Rails.cache
  end
end
