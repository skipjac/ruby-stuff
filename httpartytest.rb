require 'rubygems'
require 'httparty'
require 'pp'
require 'json'

class Zenuser
  include HTTParty
  base_uri 'skipjack.zendesk.com'
  basic_auth 'skip@techassistant.net', 'ftn4ver'
end

data =  Zenuser.get('/people.json?query=bob%40test.com')
#pp data.headers

if data.headers['status']== '200 OK'
        newJSON = JSON.parse(data.body)
        if newJSON.length > 0
            newJSON.each do |userID|
                print userID['id']
            end
        else
          print 'none found
          '
        end
       end
