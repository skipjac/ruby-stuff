# get the emails address for users in Zendesk


!#/usr/bin/env ruby
require 'rubygems'
require 'csv'
require 'pp'
require 'httparty'
require 'open-uri'
require 'json'
require 'crack'
require 'uri'


class Zenuser
  include HTTParty
  base_uri 'https://support.zendesk.com'
  headers 'content-type'  => 'application/json'
  def initialize(u, p)
      @auth = {:username => u, :password => p}
    end
  def get_users(loc)
    options = {:basic_auth => @auth}
    #print options
    self.class.get(loc, options)
  end
end

x = Zenuser.new( 'admin@this.com/token', 'thetoken')

def getList(x, path)
  CSV.open('users.csv', 'w', :force_quotes => true, :col_sep =>',') do |csv|
  begin
    resp = x.get_users(path)
    jsonResp = JSON.parse(resp.body)
    jsonResp['users'].each do |obj|
      email = obj['email']
      name = obj['name']
      phone = obj['phone']
      csv << [name, email, phone]
      pp email
    end
    if jsonResp['next_page'] != nil
      next_page = URI(jsonResp['next_page'])
    end
    path = next_page.path + '?' + next_page.query
  end while jsonResp['next_page'] != nil
  end
end

getList(x, '/api/v2/users.json')