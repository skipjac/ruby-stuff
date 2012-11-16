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
  base_uri 'https://skipjack.zendesk.com'
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

def findTagAbles(path)
  x = Zenuser.new( 'skip@techassistant.net', '')
  resp = x.get_entries(path)
  jsonResp = JSON.parse(resp.body)
  y = jsonResp['topic']
  print y['body']
  kit = PDFKit.new(y['body'])
  kit.to_pdf
  kit.to_file('/Users/smoore/Documents/Zendesk/ruby/ruby-stuff/' + y['title'].to_s + '.pdf')
end

findTagAbles('/api/v2/topics/21010498.json')