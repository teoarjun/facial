json.responseCode 200
json.responseMessage 'Notification list fetched successfully.'
json.notification @paginatable_array.map{|noti|  noti.attributes.merge(created_at_Tstamp: noti.created_at.to_i)}

json.pagination do
	json.page_no @paginatable_array.current_page
	json.per_page @per_page
	json.total_pages @paginatable_array.total_pages
	json.total_no_records @paginatable_array.total_count
end
