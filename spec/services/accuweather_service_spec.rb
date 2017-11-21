require 'rails_helper'

RSpec.describe AccuweatherService do
  describe '#weather' do
    context 'testing' do
      subject { described_class.weather(city: 'Kiev') }

      it 'return weather data in correct format' do
        allow(AccuweatherService).to receive(:city_data).with('Kiev').and_return(AccuweatherExamples::CITY_EXAMPLE)
        allow(AccuweatherService).to receive(:city_weather).with('1-324505_1_AL').and_return(AccuweatherExamples::FORECAST_EXAMPLES)

        expect(subject).to include_json(
          accuweather_temp_min: -1.9,
          accuweather_temp_max: 4.1,
          accuweather_precipitation: 65
        )
      end
    end
  end
end
