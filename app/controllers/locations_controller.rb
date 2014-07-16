class LocationsController < ApplicationController
  before_action :get_kabupaten_name, only: [:index]
  before_action :get_province_name, only: [:index]
  def index
    if params[:province] and params[:kabupaten]
      @view_mode = :kabupaten
      @locations = Location.count_by_kabupaten(params[:province], params[:kabupaten])
    elsif params[:province]
      @view_mode = :province
      @locations = Location.count_by_province(params[:province])
    else
      @view_mode = :national
      @locations = Location.count_national
    end

    @prabowo_sum = @locations.inject(0) { |sum, val| sum += val.sum_prabowo_count }
    @jokowi_sum = @locations.inject(0) { |sum, val| sum += val.sum_jokowi_count }
    @fetched_count_sum = @locations.inject(0) { |sum, val| sum += val.fetched_count }
    @total_count_sum = @locations.inject(0) { |sum, val| sum += val.total_count }
  end

  private
  def get_kabupaten_name
    @kabupaten_name = Kabupaten.find(params[:kabupaten]).name unless params[:kabupaten].blank?
  end

  def get_province_name
    @province_name = Province.find(params[:province]).name unless params[:province].blank?
  end
end
