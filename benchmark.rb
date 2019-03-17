# frozen_string_literal: true

require 'uri'
require 'net/http'

url = URI('http://app:3000/api/v1/readings/')

http = Net::HTTP.new(url.host, url.port)

request = Net::HTTP::Post.new(url)
request['content-type'] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
request['HouseholdToken'] = 'asdasd3'
request['Cache-Control'] = 'no-cache'
request['Postman-Token'] = '053518e6-2c99-420f-b08d-917d02fc4acb'
request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"temperature\"\r\n\r\n10000\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"humidity\"\r\n\r\n150\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"battery_charge\"\r\n\r\n996\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"

ts = []
n = 1000
n.times do
  t1 = Time.now
  http.request(request)
  t2 = Time.now
  ts << t2 - t1
end

puts "Average response time pf #{n} requests:"
p 'Push Readings: ' + (ts.sum*1000 / ts.count).round(1).to_s + 'ms'
