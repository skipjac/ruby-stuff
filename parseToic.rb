require 'rubygems'
require 'httparty'
require 'pp'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'crack'
require 'uri'


class Zenuser
  include HTTParty
  base_uri 'https://something.zendesk.com'
  headers 'content-type'  => 'application/json'
  def initialize(u, p)
      @auth = {:username => u, :password => p}
    end
  def get_entries(loc)
    options = {:basic_auth => @auth}
    #print options
    self.class.get(loc, options)
  end
  
	def update_tags(loc, tags)
		#options = {:basic_auth => @auth}
		json = JSON.generate "topic"=>{"tags"=>tags}
    options = { :body => json, :basic_auth => @auth}
		self.class.put(loc, options)
	end

end

def findTagAbles(path)
	x = Zenuser.new( 'skip@email.net', 'password')
	theTags = ['rubinius', 'ruby']
	thebody = Array.new
	resp = x.get_entries(path)
	jsonResp = JSON.parse(resp.body)
	y = jsonResp['topic']
	print y['tags']
	theText = Nokogiri::HTML(y['body'])
	theText.traverse{ |x|
    if x.text? and not x.text =~ /^\s*$/
			thebody.concat(x.text.gsub(/[^[:alnum:]]/, ' ').downcase.split)
    end
}
	finalList = thebody.uniq
	updateTags = finalList & theTags | y['tags']
	x.update_tags(path, updateTags)
	
end
findTagAbles('/api/v2/topics/21328379-ruby-array-comparison-tricks.json')