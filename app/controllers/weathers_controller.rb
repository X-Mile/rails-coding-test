require 'json'
require 'net/https'
require 'uri'

class WeathersController < ApplicationController
  def index
    api_key = ENV['OPEN_WEATHER_API']
    city = 'Tokyo'

    begin
      uri = URI("https://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&lang=ja&units=metric")
      response = Net::HTTP.get_response(uri)
      
      if response.code == "200"
        response_body = response.body
        @weather_data = JSON.parse(response_body)
        
        if @weather_data.present? && @weather_data['main'].present?
          @weather_description = @weather_data["weather"][0]["description"]
          @weather_temp = @weather_data["main"]["temp"]
        else
          @error_message = "必要なデータを取得できませんでした"
        end
      else
        @error_message = "無効なレスポンスです: #{response.code}"
      end
    rescue JSON::ParserError
      @error_message = "データの解析に失敗しました"
    rescue => e
      @error_message = "データの取得中にエラーが発生しました: #{e.message}"
    end
  end
end
