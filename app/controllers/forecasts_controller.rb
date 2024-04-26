class ForecastsController < ApplicationController
  def create
    ForecastRequestJob.perform_now(address)

    render turbo_stream: turbo_stream.replace(
      'forecast-details',
      partial: 'forecasts/forecast_details',
      locals: { forecast: nil }
    )
  end

  private

  def address
    forecast_params[:address]
  end

  def forecast_params
    params.permit(:address)
  end
end
