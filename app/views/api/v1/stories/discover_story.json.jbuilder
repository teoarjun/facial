json.responseCode 200
json.responseMessage 'Stories fetched successfully.'
@stories.reload
json.stories @paginatable_array do |story|
	json.(story, :id, :name, :status, :user_id, :location, :image, :time, :featured)
end
json.pagination do
	json.page_no @paginatable_array.current_page
	json.per_page @per_page
	json.total_pages @paginatable_array.total_pages
	json.total_no_records @paginatable_array.total_count
end