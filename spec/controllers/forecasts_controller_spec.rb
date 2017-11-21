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
    let(:accu_weather_data) { {
      accuweather_temp_min: -1,
      accuweather_temp_max: 3,
      accuweather_precipitation: 10,
    } }

    let(:darksky_weather_data) { { 
      darksky_temp_min: -1,
      darksky_temp_max: 2,
      darksky_precipitation: 10
     } }
    context 'recording weather data' do
      it 'should create new record' do
        allow(AccuweatherService).to receive(:weather).and_return(accu_weather_data)
        allow(DarkskyService).to receive(:weather).and_return(darksky_weather_data)
        post :create, params: { forecast: { city: 'Cherkassy' } }, xhr: true

        forecast = Forecast.first
        expect(response.status).to be(200)
        expect(Forecast.count).to be(1)
        expect(forecast.accuweather_temp_min).to be(-1)
        expect(forecast.accuweather_temp_max).to be(3)
        expect(forecast.accuweather_precipitation).to be(10)
        expect(forecast.darksky_temp_min).to be(-1)
        expect(forecast.darksky_temp_max).to be(2)
        expect(forecast.darksky_precipitation).to be(10)
        expect(forecast.city).to eq('Cherkassy')
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

    context 'when Darksky is down' do
      it 'should show error' do
        allow(DarkskyService).to receive(:weather). and_raise(DarkskyService::ServiceError)
      post :create, params: { forecast: { city: 'Cherkassy' } }, xhr: true

        expect(response.status).to be(200)
        expect(Forecast.count).to be(0)
        expect(flash[:error]).to eq('Service api.darksky.net currently unavailable!')
      end
    end
  end
end
