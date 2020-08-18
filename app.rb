require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

DATA_DIR = 'data'
SQUARE_WIDTH_OF_LONGITUDES = 0.01 # マーカを表示する、画面中心からの縦横の距離(度)

set :bind, '0.0.0.0'

get '/health_check' do
  'health check'
end

get '/markers' do
  lat, long =  params['center'].split(",").map(&:to_f)
  load_markers(lat, long)
end

def load_markers(lat, long)
  marker_area = {
    latitude: (lat - SQUARE_WIDTH_OF_LONGITUDES..lat + SQUARE_WIDTH_OF_LONGITUDES),
    longitude: (long - SQUARE_WIDTH_OF_LONGITUDES)..(long + SQUARE_WIDTH_OF_LONGITUDES),
  }
  markers = {}
  Dir.glob("#{DATA_DIR}/*.json").each do |f|
    begin
      json = open(f).read
      next if json.empty?
      data = JSON.parse(json, symbolize_names: true)
      id = data.keys.first
      pos = data.values.first
      p pos
      if (marker_area[:latitude].include?(pos[:latitude])  &&
          marker_area[:longitude].include?(pos[:longitude]))
        markers[id] = pos
      end
    rescue => e
      puts f
      puts json
      raise e
    end
  end
  JSON.dump(markers)
end
