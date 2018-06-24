json.responseCode 200
json.responseMessage 'Story created successfully.'
@story.reload
json.story do |json|
	json.(@story, :id, :name, :status, :location)
	json.time @story.time
	json.image @story.image_url
end