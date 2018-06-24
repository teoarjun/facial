ren = true
resp = HTTParty.get(@url)
images = []
resp = resp["data"].map{|data| images << {thumbnail: data["images"]["thumbnail"]["url"], standard_resolution: data["images"]["standard_resolution"]["url"]}} rescue ren = false

if ren
  json.responseCode 200
  json.responseMessage 'Images fetched successfully'
  json.images images
else
  json.responseCode 500
  json.responseMessage resp
end
