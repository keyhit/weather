class AccuweatherService
  include HTTParty

  API_KEY = ENV['ACCU_API_KEY'].freeze
  # Alternative API_KEY
  # API_KEY = 'ENV['ACCU_ALTERNATIVE_API_KEY'].freeze
  SERVICE_NAME = 'accuweather.com'.freeze
  base_uri 'http://dataservice.accuweather.com'

  class << self
    def weather(data)
      city_info = city_data(data[:city])
      id = city_info['Key']
      result = formatted_data(city_weather(id))
    end

    def city_data(city_name)
      response = get("/locations/v1/cities/search?apikey=#{API_KEY}&q=#{city_name}")
      check_response(response.code)
      response.parsed_response.first
    end

    def city_weather(city_id)
      response = get("/forecasts/v1/daily/1day/#{city_id}?apikey=#{API_KEY}&details=true&metric=true")
      check_response(response.code)
      response.parsed_response['DailyForecasts'].first
    end

    def formatted_data(data)
      {
        accuweather_temp_min: data['Temperature']['Minimum']['Value'],
        accuweather_temp_max: data['Temperature']['Maximum']['Value'],
        accuweather_precipitation: data['Day']['PrecipitationProbability']
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
