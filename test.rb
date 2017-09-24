require 'net/http'

# NOTE: You must use the same location in your REST call as you used to obtain your subscription keys.
#   For example, if you obtained your subscription keys from westus, replace "westcentralus" in the 
#   URL below with "westus".
uri = URI('https://westcentralus.api.cognitive.microsoft.com/vision/v1.0/analyze')
uri.query = URI.encode_www_form({
    # Request parameters
    'visualFeatures' => 'Categories',
    'details' => '{string}',
    'language' => 'en'
})

request = Net::HTTP::Post.new(uri.request_uri)
# Request headers
request['Content-Type'] = 'application/json'
# NOTE: Replace the "Ocp-Apim-Subscription-Key" value with a valid subscription key.
request['Ocp-Apim-Subscription-Key'] = 'KEY'
# Replace with the body, for example, "{\"url\": \"http://www.example.com/images/image.jpg\"}"
request.body = "{\"url\": \"https://upload.wikimedia.org/wikipedia/commons/1/11/Cheetah_Kruger.jpg\"}"
# request.body = File.read("12227_tapir.jpg")

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
end

puts response.body