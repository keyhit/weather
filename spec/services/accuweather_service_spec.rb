require 'rails_helper'

RSpec.describe AccuweatherService do
  describe '#weather' do
    context 'testing' do
      subject { described_class.weather(city: "Cherkassy") }

      it 'return weather data in correct format' do
        allow(AccuweatherService).to receive(:city_data).with("Cherkassy").and_return(AccuweatherExamples::CITY_EXAMPLE)
        allow(AccuweatherService).to receive(:city_weather).with("1-324505_1_AL").and_return(AccuweatherExamples::FORECAST_EXAMPLES)

        expect(subject).to include_json(
          temp_min: -1.9,
          temp_max: 4.1,
          precipitation: 65,
          source: "accuweather.com",
          city: "Cherkassy"
        )
      end
    end
  end
end