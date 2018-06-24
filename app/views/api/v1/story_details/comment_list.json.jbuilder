json.responseCode 200
json.responseMessage 'Comment list fetched successfully.'
json.comments @paginatable_array do |comment|
	json.(comment, :id, :commentable_id, :commentable_type, :comment, :user_id)
	json.user_name comment.user.name
	# json.user_image comment.user.image.url
	if comment.user.social_logins.present?
	  json.user_image comment.user.image.blank? ? {url: comment.user.social_logins.first.image} : comment.user.image
	else
	  json.user_image comment.user.image
 	end
end
json.pagination do
	json.page_no @paginatable_array.current_page
	json.per_page @per_page
	json.total_pages @paginatable_array.total_pages
	json.total_no_records @paginatable_array.total_count
end
