require 'sequel'
require 'sequel/extensions/seed'
require 'pg'
require 'json'
require 'multi_json'
require 'sinatra'
require 'sinatra/namespace'

DB = Sequel.connect(
  adapter: :postgres,
  database: 'sinatra_seq_dev',
  host: 'localhost',
  password: 'password',
  user: 'sinatra_admin',
  max_connections: 10
)

before do
  content_type 'application/json'
end

require_relative 'models/init'
require_relative 'routes/init'

error Sequel::ValidationFailed do
  status 422
  { errors: env['sinatra.error'].errors }.to_json
end

error Sequel::NoMatchingRow do
  status 404
  { error: 'No such record in Database; check params', status: 'not_found' }.to_json
end

get '/' do
  "Hi! I am api_sinatra_postgres!\n\n"
end

def collection_to_api(collection)
  MultiJson.dump(collection.map { |s| s.to_api })
end