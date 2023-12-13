require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /index" do
    let(:valid_weather_mock) { double('response', code: '200', body: '{"name": "Tokyo", "weather": [{"description": "clear"}], "main": {"temp": 25}}') }
    let(:missing_data_weather_mock) { double('response', code: '200', body: '{"name": "city_without_data", "data": "no_data"}') }
    
    context "正しい場所を入力したとき" do
      it "ステータスコード200が返ってくること" do
        allow(Net::HTTP).to receive(:get_response).and_return(valid_weather_mock)

        get "/weathers/index", params: { city: "Tokyo"}

        expect(Net::HTTP).to have_received(:get_response)
        expect(response).to have_http_status(:ok)
      end
    end

    context "正しいデータがないとき" do
      it "エラーメッセージが表示されること" do
        allow(Net::HTTP).to receive(:get_response).and_return(missing_data_weather_mock)

        get "/weathers/index", params: { city: 'city_without_data' }

        @error_message = controller.instance_variable_get("@error_message")
        expect(@error_message).to eq(I18n.t('errors.data_unavailable'))
      end
    end
    
    context "正しい場所を入力しないとき" do
      it "ステータスコード404とエラーメッセージが返ってくること" do

        response = Net::HTTPResponse.new(nil, 404, 'Not Found')
        allow(Net::HTTP).to receive(:get_response).and_return(response)

        get "/weathers/index", params: { city: 'unknown_city'}

        @error_message = controller.instance_variable_get("@error_message")
        expect(@error_message).to eq(I18n.t('errors.invalid_response', code: response.code))
      end
    end

    context "APIリクエストの例外発生した時" do
      it "エラーが発生すること" do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError, 'Connection error')

        get '/weathers/index', params: { city: 'Tokyo' }

        @error_message = controller.instance_variable_get("@error_message")
        expect(@error_message).to eq(I18n.t('errors.fetch_error', message: 'Connection error'))
      end
    end
  end
end
