class Api::V1::StoriesController < ApplicationController
  before_action :authentication
  before_action :find_story, only: [:delete_story, :report_abuse, :update_story, :update_story_android]

  def get_story

  end

  def delete_story
    if @story.user == @user
      if @story.destroy
        return render_message 200, "Successfully deleted."
      else
        return render_message 500, "Something went wrong."
      end
    else
      return render_message 501, "You are not authenticated to perform this action."
    end
  end

  def delete_comment
	comment = Comment.find_by(id: params[:id])
  	if comment && comment.destroy
      render_message 200, 'Comment deleted successfully'
    else
       render_message 500, 'Comment not found'
    end
  end

  def report_abuse
    if @story.update(status: 'private')
      @story.story_tags.destroy_all if @story.story_tags.present?
      # tag users to story
      return render_message 200, "Reported successfully"
    else
      return render_message 500, "#{@story.errors.full_messages}"
    end
  end


  def create_story # Upload the story
    @story = @user.stories.new(story_params)
      if @story.save
        # tag users to story
        tag_users(@story,params[:story][:all_user_tags])
      else
        return render_message 500, "#{@story.errors.full_messages}"
      end

  end

  def update_story
      params[:photo] = Image.image_data(params[:photo]) if params[:phone_type] == "iPhone"
      image = @story.images.new(photo: params[:photo], facial_response: params[:facial_response])
      if image.save
        tag_users(image,params[:tagged_users])
      else
        return render_message 500, "#{image.errors.full_messages}"
      end
  end

  def update_story_android
      params[:photo] = Image.image_data(params[:photo]) if params[:phone_type] == "iPhone"
      params[:facial_response] = JSON.parse(params[:facial_response]) rescue params[:facial_response]
      image = @story.images.new(photo: params[:photo], facial_response: params[:facial_response])
      if image.save
        params[:tagged_users] = (params[:tagged_users].values rescue [])
        tag_users(image,params[:tagged_users])
      else
        return render_message 500, "#{image.errors.full_messages}"
      end
  end

  def discover_story # Fetch list of stories with status public
    @stories = Story.where(status: 'public').order(created_at: :desc)
    if @stories
      @per_page = params[:per_page]
      @paginatable_array = Kaminari.paginate_array(@stories).page(params[:page]).per(params[:per_page])
    else
      return render_message 500, "Story not found."
    end
  end

  def search_user
    # @user = User.search(params[:name])
    # user_ids = @user.pluck(:id)
    # @data = Story.joins(:user).where('stories.user_id IN (?) and stories.status=?',user_ids,'public')
    #NEW FOR TAGGED BASED SEARCH
    tagged_mem = []
    tagged_mem << StoryTag.where('taggable_type = ? and tagged_name ILIKE ?',"Story", "%#{params[:name].downcase}%").pluck(:taggable_id)
    @data = Story.where('id in (?)', tagged_mem.flatten).where.not('status = ?',  'private')
    # NEW ENDS HERE

    @per_page = params[:per_page]
    @paginatable_array = Kaminari.paginate_array(@data).page(params[:page]).per(params[:per_page])
  end

  def user_list
    @list = User.all - [@user]
    if @list
      @per_page = params[:per_page]
      @paginatable_array = Kaminari.paginate_array(@list).page(params[:page]).per(params[:per_page])
    end
  end


    def tag_user
       if params[:type] == "story"
        find_story
          unless (@story.user_id == @user.id)
            return render_message 501, "You are not authenticated to perform this action."
          end
          tags = tag_users(@story,params[:user_ids])
        # tag = params[:user_ids].map{ |x| @story.story_tags.where(user_id: x).first_or_create }
      elsif params[:type] == "image"
        @image = Image.find_by(id:  params[:id])
        return render_message 500, "Image not found." unless @image
        tags = tag_users(@image,params[:user_ids])
        # tag = params[:user_ids].map{ |x| image.story_tags.where(user_id: x).first_or_create }
      else
        return render_message 500, "Please provide a type."
      end
      return render_message 200, "Tagged successfully."
    end


    def untag
      if params[:type] == "story"
        find_story
          unless (params[:user_id] == @user.id) || (@story.user_id == @user.id)
            return render_message 501, "You are not authenticated to perform this action."
          end
        tag = find_tag(@story,params[:user_id])
      elsif params[:type] == "image"
        image = Image.find_by(id:  params[:id])
        return render_message 500, "Image not found." unless image
        tag = find_tag(image,params[:user_id])
      else
        return render_message 200, "Please provide a type."
      end
      destroy_tag(tag)
    end


private
  def story_params
    params[:story][:image] = Story.image_data(params[:story][:image].to_s.gsub("\\r\\n", '')) if params[:story][:image].present?
    params.require(:story).permit(:name, :image, :time, :location, :status)
  end

  def tag_users(obj,user_ids)
    if user_ids.count > 0
      user_ids = user_ids - [[@user.id.to_s,@user.facial_ipseity, @user.name]]
      user_ids.map do |x|
          u_id =  (x[0].to_i == 0) ? nil : x[0].to_i
          tag = obj.story_tags.find_or_create_by(user_id: u_id, person_id: x[1], tagged_name: x[2])
          # remove "if obj.class.name.downcase == 'story'" from below when implementedfor image
          if x[0].to_i != 0
           notify_user(obj.class.name.downcase, x[0].to_i, obj.id) if (obj.class.name.downcase == 'story')
           obj.notifications.create(user_id: x[0].to_i, content: "#{@user.name.camelcase} tagged you in a #{obj.class.name.downcase}", subject: "Tag") if (x[0] != @user.id && obj.class.name.downcase == 'story' )
          end
        end
    end
  end

  def notify_user(obj_type, user_id, object_id)
      user = User.find_by(id: user_id.to_i)
      if ((user.devices.present? && user.noti_type == true) && (user_id.to_i != @user.id))
        NotificationJob.perform_now(user.devices.last.device_type,
                                    user.devices.last.device_token,
                                    "#{@user.name} tagged you in a #{obj_type}",
                                    "tag",
                                    object_id)
      end
  end

  def find_tag(obj,id)
      obj.story_tags.find_by(user_id: id)
  end

  def destroy_tag(tag)
    if tag and tag.destroy
      return render_message 200, "Untagged Successfully."
    else
      return render_message 500, "Tag not found."
    end
  end

end
