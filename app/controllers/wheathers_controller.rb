require 'json'
require 'net/https'
require 'uri'

class WheathersController < ApplicationController
  def index
    api_key = ENV['OPEN_WEATHER_API']
    city = 'Tokyo'

    uri = URI("http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&lang=ja&units=metric")
    response = Net::HTTP.get(uri)
    @weather_data = JSON.parse(response)
    if @weather_data.present?
      @weather_description = @weather_data["weather"][0]["description"]
      @weather_temp = @weather_data["main"]["temp"]
    else
      @error_message = "取得できませんでした"
    end
  end
end
