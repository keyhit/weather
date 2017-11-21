require 'rails_helper'

RSpec.describe DarkskyService do
  describe '#weather' do
    context 'testing' do
      subject { described_class.weather('Kiev') }

      it 'return weather data in correct format' do
        allow(DarkskyService).to receive(:coordinates_by_name).with('Kiev').and_return(DarkskyServiceExamples::COORDINATES_EXAMPLE)
        allow(DarkskyService).to receive(:forecast_by_coordinates).with('lat' => 50.4501, 'lng' => 30.5234).and_return(DarkskyServiceExamples::FORECAST_EXAMPLES)

        expect(subject).to include_json(
          darksky_temp_min: -1,
          darksky_temp_max: 2,
          darksky_precipitation: 10
        )
      end
    end
  end
end
