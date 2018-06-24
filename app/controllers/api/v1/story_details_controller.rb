class Api::V1::StoryDetailsController < ApplicationController
	before_action :authentication
	before_action :find_story, except: [:unlike_story, :reply_comment]

	def like_story # Create like on story
    	return render_message 500, 'You have already liked this story.' if @story.likes.find_by(user_id: @user.id, status: true)
		@like = @story.likes.build(user_id: @user.id)
		if @like.save
			user = @story.user
			NotificationJob.perform_now(user.devices.last.device_type,user.devices.last.device_token, "#{@user.name} likes your story", "like",@story.id) if ((user.devices.present? && user.noti_type == true) && (user != @user))
			@story.notifications.create(user_id: user.id, content: "#{@user.name} likes your story", subject: "Like") if (user!= @user)
		else
			return render_message 500, "#{@like.errors.full_messages}"
		end
	end

	def view_story
		@story.view_stories.create(user_id: @user.id) unless @story.view_stories.find_by(user_id: @user.id)
		@view_count = @story.view_stories.count
		@comments = @story.comments
		@like = @story.likes.find_by(user_id: @user.id)
		if @like
			@like_status = true
		else
			@like_status = false
		end
	end

	def unlike_story # Unlike the story
		@like = Like.find_by(id: params[:like_id])
		if @like
			@like.destroy
		else
			return render_message 500, "Like not found."
		end
	end

	def comment_story # Create comment on story
		@comment = @story.comments.build(comment: params[:comment], user_id: @user.id)
		if @comment.save
			user = @story.user
			NotificationJob.perform_now(user.devices.last.device_type,user.devices.last.device_token, "#{@user.name} commented on your story", "comment" , @story.id) if ((user.devices.present? && user.noti_type == true) && (user != @user))
			@story.notifications.create(user_id: user.id, content: "#{@user.name} commented on your story", subject: "Comment") if (user!= @user)
		else
			return render_message 500, "#{@comment.errors.full_messages}"
		end
	end

	def comment_list # Fetch all the comments of the story
		@comments = @story.comments.order(created_at: :desc).reverse
		if @comments.reverse
			@per_page = params[:per_page]
			@paginatable_array = Kaminari.paginate_array(@comments).page(params[:page]).per(params[:per_page])
		else
			return 500, "No comments found."
		end
	end

	def reply_comment # Create reply on comment
		@comment = Comment.find_by(id: params[:comment_id])
		if @comment
			@reply = @comment.comments.build(comment: params[:comment], user_id: @user.id)
			if @reply.save
				user = @comment.user
				NotificationJob.perform_now(user.devices.last.device_type,user.devices.last.device_token, "#{@user.name} replied to your comment.", "reply", @comment.id) if (user.devices.present? && user.noti_type == true)
				@comment.notifications.create(user_id: user.id, content: "#{@user.name} replied on your comment.", subject: "reply")
			else
				return render_message 500, "#{@reply.errors.full_messages}"
			end
		else
			return render_message 500, 'Comment not found.'
		end
	end
end
