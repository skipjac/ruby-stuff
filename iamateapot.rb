require 'sinatra'
require 'Haml'
set :haml, :format => :html5
#set :views, settings.root + '/templates'

enable :sessions

get '/:value' do
  status 418
  headers \
    "Allow"   => "BREW, POST, GET, PROPFIND, WHEN",
    "Refresh" => "Refresh: 20; http://www.ietf.org/rfc/rfc2324.txt"
    @title = Time.now.to_s()
    @start = 10
    @end = 15
    #content
    puts session[:value] = params[:value]
      haml :index
    
end

post '/bar' do 
  puts request.body.read
  puts @params.inspect
end