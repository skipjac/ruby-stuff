require 'pp'
require 'net/https'
require 'crack'
require 'json'

http = Net::HTTP.new('skipjack.zendesk.com', 443)
http.use_ssl = true
count = 1
newJSON = 'test'
begin
http.start do |http|
   req = Net::HTTP::Get.new('/people?query=bob%40test.com&page=' + count.to_s)

   # we make an HTTP basic auth by passing the
   # username and password
   req.basic_auth 'skip@techassistant.net', 'password'
   resp, data = http.request(req)
   newJSON = JSON.parse(data)
   
   if newJSON.length > 0
      # pp newJSON[0]
      newJSON.each do |test|
        if test['email']
          pp test
        end
        
      end
      print newJSON.length.to_s + '
      '
    else
      print 'none found
      '
      print count.to_s + '
      '
    end
    count += 1
 end
end while newJSON.length > 0
