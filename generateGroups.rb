require 'rubygems'
require 'httparty'
require 'pp'
require 'json'
require 'FileUtils'
require 'open-uri'
require 'nokogiri'

class Zenuser
  include HTTParty
  base_uri 'https://z3nofskip.zendesk.com'
  headers 'content-type'  => 'application/json'
  def initialize(u, p)
      @auth = {:username => u, :password => p}
    end
  def post(f)
    json = JSON.generate "group"=>{"name"=>f}
    options = { :body => json, :basic_auth => @auth}
    #print options
    self.class.post('/api/v1/entries.json', options)
  end
  
end

x = Zenuser.new( 'email@gmail.com/token', 'token')
  
for s in 1...10
  newGroup = "Skip Group " + ss
  data = x.post(newGroup)
  pp data.headers
  if data.headers['status']== '201 Created'
          print data.headers['location'] + "\n"
        else
          print data.headers['status'] + "\n"
    end
end