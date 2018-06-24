class Api::V1::MemoriesController < ApplicationController
	before_action :authentication

	def my_memory
		@memories = []
		tagged_stories = StoryTag.where(taggable_type: "Story", user_id: @user.id).pluck(:taggable_id).uniq #stories where user is tagged
		story = Story.where('id in (?)' , tagged_stories)
		@memories << story
		@memories << @user.stories # Stories created by user
		@stories = @memories.flatten(2).uniq.sort.reverse
		@stories = @stories.map{|m| m.attributes.merge(created_at_tStamp: m.created_at.to_i,album_images: m.images.present? ? m.images.map{ |img| img.as_json(except: [:created_at, :updated_at]).merge(facial_response: img.facial_respons )} : [] )}
		@per_page = params[:per_page]
        @paginatable_array = Kaminari.paginate_array(@stories).page(params[:page]).per(@per_page)

		return render_message 500, "No memory found." unless @stories

	end

	def search_memory
      @users = User.search(params[:name])
			@memories = []
			stories = []
			tagged_mem = []
      created_stories = []

      if (@user.name.downcase.include?(params[:name].downcase))
				created_stories << @user.stories.pluck(:id)
			end

			@users.each do |user|
			   stories  << user.stories.pluck(:id)
			end
#Location based stories:
			location_based_stories = Story.where('location ILIKE ? ', "%#{params[:name]}%")
			stories << location_based_stories
#Location based
 			location_based_user_stories = Story.where('location ILIKE ? and user_id = ?', "%#{params[:name]}%",@user.id )

			stories.flatten(1).each do |story_id|
			   tagged_mem << StoryTag.where(taggable_type: "Story", taggable_id: story_id , user_id: @user.id).pluck(:taggable_id)
			end

			@memories = Story.where('id in (?)', tagged_mem.flatten(1) ).where.not('status = ?',  'private')
      @memories = @memories + Story.where(id: created_stories) + location_based_user_stories
      @memories = @memories.uniq.sort_by{|s| [:created_at]}.map do |m|
				m.attributes.merge(image: m.image.url , created_at_tStamp: m.created_at.to_i,
				album_images: m.images.present? ? m.images.map{|img| img.attributes.merge(photo: img.photo ,facial_response: img.facial_respons)} : [] )
			end.reverse
			@per_page = params[:per_page]
			@paginatable_array = Kaminari.paginate_array(@memories).page(params[:page]).per(@per_page)

	end


end
