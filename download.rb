
require 'sinatra'

get '/download/*.*' do |path, ext|
  [path, ext] # => ["path/to/file", "xml"]
end