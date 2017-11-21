class ForecastsController < ApplicationController
  rescue_from AccuweatherService::ServiceError do |e|
    render_error(e.to_s)
  end

  rescue_from DarkskyService::ServiceError do |e|
    render_error(e.to_s)
  end

  rescue_from AccuweatherService::ServiceErrorNotFound do |e|
    render_error(e.to_s)
  end

  rescue_from DarkskyService::ServiceErrorNotFound do |e|
    render_error(e.to_s)
  end

  def index
    current_user
  end

  def create
    accuweather_sourse = AccuweatherService.weather(forecast_params)
    darksky_sourse = DarkskyService.weather(forecast_params)
    sourses = accuweather_sourse.merge(darksky_sourse)
    current_user.forecasts.create(forecast_params.merge(sourses))
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
