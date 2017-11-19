class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    return @current_user if @current_user
    @current_user = User.find_or_create_by(id: cookies[:user_id])
    cookies[:user_id] = @current_user.id unless cookies[:user_id].present?
    @current_user
  end
end
