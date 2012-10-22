require 'rubygems'
require 'httparty'
require 'pp'
require 'FileUtils'
#require 'open-uri'
require 'json'
require 'crack'
require 'uri'
require 'csv'

class Zenuser
  include HTTParty
  base_uri 'https://rypple.zendesk.com'
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

x = Zenuser.new( 'email@email.com', 'password!')
path = '/api/v2/topics.json'

begin
  pp path
  #x.get_entries(path)
  resp = x.get_entries(path)
  rtnJSON = JSON.parse(resp.body)
  if rtnJSON['next_page'] != nil
    next_page = URI(rtnJSON['next_page'])
  end
  pp rtnJSON['next_page']
  path = next_page.path + '?' + next_page.query
  rtnJSON['topics'].each do |topic|
    votes = x.get_entries('/api/v2/topics/' + topic['id'].to_s + '/votes.json')
    #pp votes['topic_votes']
    File.open("file.csv", "a") do |the|
      if votes['topic_votes'].length > 0
        votes['topic_votes'].each do |test|
          skip = test['id'].to_s + ',' + test['user_id'].to_s + ',' + test['topic_id'].to_s + ',' + test['created_at']
          the.puts skip
        end
      end
    end
  end
end while rtnJSON['next_page'] != nil