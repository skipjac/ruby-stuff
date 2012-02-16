require 'rubygems'
require 'httparty'
require 'pp'
require 'json'
require 'FileUtils'


class Zenuser
  include HTTParty
  base_uri 'skipjack.zendesk.com'
  headers 'content-type'  => 'application/binary'
  def initialize(u, p)
      @auth = {:username => u, :password => p}
    end
  def post(f, t)
    options = { :body => t, :basic_auth => @auth}
    #print options
    self.class.post('/attachments/create.json?filename=' + f, options)
  end
  
end

x = Zenuser.new( 'email@gmail.com/token', 'token')

FileUtils.cd('/Users/skipmoore/Documents/Zendesk/engineyard/engineyard/images')
print FileUtils.pwd()
files = Dir.glob('*.png')
files.each do |s|
  titleHTML = File.basename(s)
  #print titleHTML + "  "
  file = File.open(s, "rb")
  bodyHTML = file.read
  print titleHTML + "\n"
  data = x.post(titleHTML, bodyHTML)
  pp data.headers
  print "\n"
  if data.headers['status']== '200 OK'
    newJSON = JSON.parse(data.body)
    print newJSON['url'] + "\n"
  else
    print data.headers['status'] + "\n"
  end
end