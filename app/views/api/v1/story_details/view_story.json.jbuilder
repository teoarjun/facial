json.responseCode 200
json.responseMessage 'Story fetched successfully.'
@story.reload
json.story do |json|
	json.(@story, :id, :name, :status, :user_id, :location)
	json.time @story.time.to_i
	# json.tag_user @tag
	json.image @story.image.url
	# json.user_image @story.user.image.url
	if @story.user.social_logins.present?
	  json.user_image @story.user.image.blank? ? {url: @story.user.social_logins.first.image} : @story.user.image
	else
	  json.user_image @story.user.image
 	end

	json.user_name @story.user.name
	json.story_album @story.images.map{ |img| img.as_json(except: [:created_at, :updated_at]).merge(facial_response: img.facial_respons )}
end
json.likes_count @story.likes.count
json.like @story.likes
json.comments_count @story.comments.count
json.comments @comments do |comment|
	json.(comment, :id, :commentable_id, :commentable_type, :comment, :user_id)
	json.user_name comment.user.name
	json.user_image comment.user.image.url
	if comment.user.social_logins.present?
	  json.user_image comment.user.image.blank? ? {url: comment.user.social_logins.first.image} : comment.user.image
	else
	  json.user_image comment.user.image
 	end

end
json.views 	@view_count
json.like_status @like_status
json.like @like
