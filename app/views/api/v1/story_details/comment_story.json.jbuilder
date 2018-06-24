json.responseCode 200
json.responseMessage 'Comment created successfully.'
json.comment(@comment, :id, :commentable_id, :commentable_type, :comment, :user_id)
