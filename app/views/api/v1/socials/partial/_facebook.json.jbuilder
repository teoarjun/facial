ren = true
resp = HTTParty.get(@url)
images = []
resp = resp["photos"]["data"].map{|i| images << { thumbnail: i["images"][-1]["source"], standard_resolution: i["images"][0]["source"]} } rescue ren = false

if ren
  json.responseCode 200
  json.responseMessage 'Images fetched successfully'
  json.images images
else
  json.responseCode 500
  json.responseMessage 'There is something wrong with the token'
end
