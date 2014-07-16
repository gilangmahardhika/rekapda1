class Location < ActiveRecord::Base
  belongs_to :province
  belongs_to :kabupaten
  belongs_to :kecamatan

  def self.count_by_kabupaten(province_id, kabupaten_id)
    includes(:kecamatan).select('province_id', 'kabupaten_id', 'kecamatan_id',
                             'sum(jokowi_count) as sum_jokowi_count', 'sum(prabowo_count) as sum_prabowo_count',
                             'max(last_fetched_at) as max_last_fetched_at',
                             'count(last_fetched_at) as fetched_count',
                             'count(*) as total_count').
    where(:province_id => province_id, :kabupaten_id => kabupaten_id).
    group(:province_id, :kabupaten_id, :kecamatan_id).
    order(:kecamatan_id)
  end

  def self.count_by_province(province_id)
    includes(:kabupaten).select('province_id', 'kabupaten_id',
                             'sum(jokowi_count) as sum_jokowi_count', 'sum(prabowo_count) as sum_prabowo_count',
                             'max(last_fetched_at) as max_last_fetched_at',
                             'count(last_fetched_at) as fetched_count',
                             'count(*) as total_count').
    where(:province_id => province_id).
    group(:province_id, :kabupaten_id).
    order(:kabupaten_id)
  end

  def self.count_national
    includes(:province).select('province_id',
                             'sum(jokowi_count) as sum_jokowi_count', 'sum(prabowo_count) as sum_prabowo_count',
                             'max(last_fetched_at) as max_last_fetched_at',
                             'count(last_fetched_at) as fetched_count',
                             'count(*) as total_count').
    group(:province_id).
    order(:province_id)
  end

  def detail_url
    "http://pilpres2014.kpu.go.id/da1.php?cmd=select&grandparent=#{self.kabupaten_id}&parent=#{self.kecamatan_id}"
  end
end
