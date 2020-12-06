class Api::MinorsController < ApplicationController
  def index
    minors= Minor.all.collect
    minors_data = []

    minors.each do |minor|
      minor_data =  minor.as_json_for_main_page
      minor_data[:url] = api_minor_url(minor)

      minors_data << minor_data
    end

    render json: minors_data
  end

  def show
    minor = Minor.find(params[:id])
    minor_data = minor.as_json_for_main_page
    minor_data[:url] = api_minor_url(minor)

    render json: minor_data
  end
end
