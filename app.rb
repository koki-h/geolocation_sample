require 'sinatra'
require 'sinatra/reloader' if development?


set :bind, '0.0.0.0'

get '/health_check' do
  'health check'
end

get '/markers' do
  p params['center']
  puts "bbb"
end
