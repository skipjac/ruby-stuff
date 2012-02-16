require 'rubygems'
require 'httparty'
require 'pp'
require 'json'
require 'FileUtils'
require 'open-uri'
require 'nokogiri'

class Zenuser
  include HTTParty
  base_uri 'https://engineyard.zendesk.com'
  headers 'content-type'  => 'application/json'
  def initialize(u, p)
      @auth = {:username => u, :password => p}
    end
  def post(f, t)
    json = JSON.generate "entry"=>{"forum_id"=>"20577161","title"=>f,"text"=>t}
    options = { :body => json, :basic_auth => @auth}
    #print options
    self.class.post('/api/v1/entries.json', options)
  end
  
end

x = Zenuser.new( 'email@gmail.com/token', 'token')


  

FileUtils.cd('/Users/skipmoore/Documents/Zendesk/engineyard/engineyard/pages')
print FileUtils.pwd()
files = Dir.glob('*.html')
files.each do |s|
  #titleHTML = File.basename(s, ".html")
  titleHTML =""
  #print titleHTML + "  "
  file = File.open(s, "r")
  bodyHTML = file.read
  doc = Nokogiri::HTML(bodyHTML)
  #print doc
  doc.css('h1').each do |h1|
    titleHTML = h1.text
  end
  data = x.post(titleHTML, bodyHTML)
  pp data.headers
  if data.headers['status']== '201 Created'
          print data.headers['location'] + "\n"
        else
          print data.headers['status'] + "\n"
    end
end