require 'sinatra'

set :bind, '0.0.0.0'

get '/health_check' do
  'health check'
end
