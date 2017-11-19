class AccuweatherService
  include HTTParty

  API_KEY = 'VOPAdTPRJxsGFq8bV8AljU2FRXxLQiqn'
  # API_KEY = 'NaxQP42hOVhAZQY5LojWJlh8xmiHiHUa'
  SERVISE_NAME = "accuweather.com"
  base_uri 'http://dataservice.accuweather.com'

  class << self
    def weather(data)
      city_info = city_data(data[:city])
      id = city_info['Key']
      result = formatted_data(city_weather(id))
      result.merge(source: SERVISE_NAME, city: data[:city])
    end

    def city_data(city_name)
      response = get("/locations/v1/cities/search?apikey=#{API_KEY}&q=#{city_name}")
      check_response(response.code)
      response.parsed_response.first
    end

    def city_weather(city_id)
      response = get("/forecasts/v1/daily/1day/#{city_id}?apikey=#{API_KEY}&details=true&metric=true")
      check_response(response.code)
      response.parsed_response["DailyForecasts"].first
    end

    def formatted_data(data)
      {
        temp_min: data["Temperature"]["Minimum"]["Value"],
        temp_max: data["Temperature"]["Maximum"]["Value"],
        precipitation: data["Day"]["PrecipitationProbability"]
      }
    end

    def check_response(response_status)
      case response_status
      when 404
      when 500...600
        raise ServiceError
      end
    end
  end

  class ServiceError < StandardError
    def initialize()
      super "Service #{SERVISE_NAME} currently unavailable!"
    end
  end

end
