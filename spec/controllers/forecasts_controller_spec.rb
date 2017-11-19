require 'rails_helper'

RSpec.describe ForecastsController do
  describe 'GET #index' do
    context 'when new user' do
      it 'should create new user' do
        get :index

        expect(response.status).to be(200)
        expect(response).to render_template(:index)
        expect(User.count).to be(1)
        expect(cookies[:user_id]).to eq(User.first.id.to_s)
      end
    end

    context 'when user exists' do
      let(:user) { create(:user) }

      it 'test' do
        cookies[:user_id] = user.id
        get :index 

        expect(response.status).to be(200)
        expect(response).to render_template(:index)
        expect(User.count).to be(1)
      end
    end
  end

  describe 'POST #create' do
    let(:weather_data) { {
      temp_min: -1,
      temp_max: 10,
      precipitation: 50,
      source: "accuweather.com",
      city: "Cherkassy"
    } }

    context 'recording weather data' do
      it 'should create new record' do
        allow(AccuweatherService).to receive(:weather).and_return(weather_data)
        post :create, params: { forecast: { city: 'Cherkassy' } }, xhr: true

        forecast = Forecast.first
        expect(response.status).to be(200)
        expect(Forecast.count).to be(1)
        expect(forecast.temp_min).to be(-1)
        expect(forecast.temp_max).to be(10)
        expect(forecast.precipitation).to eq("50")
        expect(forecast.source).to eq("accuweather.com")
        expect(forecast.city).to eq("Cherkassy")
      end
    end

    context 'when Accuweather is down' do
      it 'should show error' do
        allow(AccuweatherService).to receive(:weather).and_raise(AccuweatherService::ServiceError)
        post :create, params: { forecast: { city: 'Cherkassy' } }, xhr: true

        expect(response.status).to be(200)
        expect(Forecast.count).to be(0)
        expect(flash[:error]).to eq('Service accuweather.com currently unavailable!')
      end
    end
  end
end