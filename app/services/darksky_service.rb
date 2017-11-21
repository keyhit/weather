class DarkskyService
  include HTTParty

  SERVICE_NAME = 'api.darksky.net'.freeze

  API_DARKSKY_KEY = ENV['API_DARKSKY_KEY'].freeze

  class << self
    def weather(name)
      coordinates = coordinates_by_name(name)
      forecast =  forecast_by_coordinates(coordinates)
      formatted_data(forecast)
    end

    def coordinates_by_name(name)
      response = get("http://maps.google.com/maps/api/geocode/json?address=#{name}")
      check_response(response.code)
      location = response.parsed_response.first.second.first['geometry']['location']
    end

    def forecast_by_coordinates(location)
      response = get("https://api.darksky.net/forecast/#{API_DARKSKY_KEY}/#{location['lat']},#{location['lng']}?units=si")
      check_response(response.code)
      response = response.parsed_response
    end

    def formatted_data(response)
      {
        darksky_temp_min: response['daily']['data'].first['temperatureMin'],
        darksky_temp_max: response['daily']['data'].first['temperatureMax'],
        darksky_precipitation: response['daily']['data'].first['precipProbability']
      }
    end

    def check_response(response_status)
      case response_status
      when 404
        raise ServiceErrorNotFound
      when 500...600
        raise ServiceError
      end
    end
  end

  class ServiceErrorNotFound < StandardError
    def initialize
      super "Service #{SERVICE_NAME} currently not found!"
    end
  end

  class ServiceError < StandardError
    def initialize
      super "Service #{SERVICE_NAME} currently unavailable!"
    end
  end
end
