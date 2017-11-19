class ForecastsController < ApplicationController
  rescue_from AccuweatherService::ServiceError do |e|
    render_error(e.to_s)
  end

  def index
   current_user
  end

  def create
    weather = AccuweatherService.weather(forecast_params)
    current_user.forecasts.create(weather)
    redirect_to forecasts_path
  end

  private

   def forecast_params
    params.require(:forecast).permit(:city)
  end

  def forecasts
   @forecasts ||= current_user.forecasts.order(created_at: :desc)
  end
  helper_method :forecasts

  def render_error(error)
    flash[:error] = error
    redirect_to forecasts_path
  end
end
