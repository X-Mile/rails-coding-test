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
          @error_message = I18n.t("errors.data_unavailable")
        end
      else
        @error_message = I18n.t("errors.invalid_response", code: response.code)
      end
    rescue => e
      @error_message = I18n.t("errors.fetch_error", message: e.message)
    end
  end
end