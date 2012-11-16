!#/usr/bin/env ruby
require 'rubygems'
require 'pdfkit'
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
  def get_entries(loc)
    options = {:basic_auth => @auth}
    #print options
    self.class.get(loc, options)
  end

end
x = Zenuser.new( 'skip@te.com', '')
def getTopic(path, x)
  resp = x.get_entries(path)
  jsonResp = JSON.parse(resp.body)
  y = jsonResp['topic']
  title = y['title'].gsub(/\s/,'-').gsub(/\//,'-')
  kit = PDFKit.new(y['body'])
  kit.to_pdf
  kit.to_file('/Users/smoore/Documents/Zendesk/ruby/ruby-stuff/' + title + '.pdf')
end

def getList(x, path)
  
  begin
    resp = x.get_entries(path)
    jsonResp = JSON.parse(resp.body)
    jsonResp['topics'].each do |obj|
      uri = URI::parse(obj['url'])
      getTopic(uri.path, x)
      pp uri.path
    end
    if jsonResp['next_page'] != nil
      next_page = URI(jsonResp['next_page'])
    end
    path = next_page.path + '?' + next_page.query
  end while jsonResp['next_page'] != nil
end
getList(x, '/api/v2/topics.json')
