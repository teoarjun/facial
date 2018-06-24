json.responseCode 200
json.responseMessage 'Story List fetched successfully'
json.memory_list @paginatable_array

json.pagination do
	json.page_no @paginatable_array.current_page
	json.per_page @per_page
	json.total_pages @paginatable_array.total_pages
	json.total_no_records @paginatable_array.total_count
end