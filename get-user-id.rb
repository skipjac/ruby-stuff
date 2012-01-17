require 'pp'
require 'net/https'
require 'crack'
require 'json'

def skippy (email)
    http = Net::HTTP.new('skipjack.zendesk.com', 443)
    http.use_ssl = true
    
    http.start do |http|
       req = Net::HTTP::Get.new('/people.json?query=' + email)
    
       # we make an HTTP basic auth by passing the
       # username and password
       req.basic_auth 'skip@techassistant.net', 'password'
       resp, data = http.request(req)
       
        print resp
       
       newJSON = JSON.parse(data)
    if Net::HTTPOK
       if newJSON.length > 0
            pp newJSON
            newJSON.each do |userID|
                print userID['id']
                end
        else
          print 'none found
          '
         end
      end
    end 
end
skippy('bob@test.com')
