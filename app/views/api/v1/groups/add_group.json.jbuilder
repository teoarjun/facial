json.responseCode 200
json.responseMessage 'Group created successfully.'
json.group do |json|
	json.(@group, :id, :name)
	json.members @members
end