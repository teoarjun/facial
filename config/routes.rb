Rails.application.routes.draw do
  # get 'homes/index'


  get 'insta_url'  =>  'static_content#insta_url'
  # devise_for :users
  post 'get_details' => 'analytics#get_details'
  get 'validate_admin_email' => 'static_content#validate_admin_email'
  get 'validate_admin_password' => 'static_content#validate_admin_password'
  get 'forgot_password_email' => 'static_content#forgot_password_email'
  get 'check_user_email' => 'static_content#check_user_email'
  get 'check_admin_user' => 'static_content#check_admin_user'
  get 'check_admin_user_name' => 'static_content#check_admin_user_name'
  # get 'get_user_name' => 'static_content#get_user_name'
  post 'admin_user/change_password/:id' => 'static_content#change_password',:as =>"change_password"
  root to: "homes#index"
  post 'contact_us' => 'homes#contact_us'
  # devise_for :users, controllers: { sessions: 'users/sessions',
                      # registrations: 'users/registrations',
                      # passwords: 'users/passwords'  }

  devise_for :admin_users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   api_version(:module => "Api/V1", :header => {:name => "Accept", :value => "application/facialapp.com; version=1"}) do
     	resources :users do
     		collection do
     			post 'sign_up'
     			post 'login'
          post 'search_user'
          get 'view_profile'
          post 'update_profile'
          delete 'logout'
          post 'get_user_name'
          post 'check_users_presence'
     	  end
     	end
      resources :passwords do
        collection do
          post 'change_password'
          post 'forget_password'
        end
      end
      resources :social_logins do
        collection do
          post 'social_login'
        end
      end
      resources :notifications do
        collection do
          post 'noti_type'
          get 'notification_list'
          delete 'delete_notification'
        end
      end
      resources :static_contents do
        collection do
          get 'about_us'
          get 'terms_and_services'
        end
      end
      resources :stories do
        collection do
          post 'create_story'
          get 'discover_story'
          post 'search_user'
          put 'tag_user'
          delete 'untag'
          get 'user_list'
          put 'update_story'
	        post 'delete_comment'
          post 'update_story_android'
          post 'report_abuse'
          post 'delete_story'
        end

        member do
          get 'get_story'
        end
      end
      resources :story_details do
        collection do
          get 'like_story'
          get 'unlike_story'
          post 'comment_story'
          get 'comment_list'
          post 'reply_comment'
          get 'view_story'


        end
      end
      resources :memories do
        collection do
          get 'my_memory'
          post 'search_memory'
        end
      end
      resources :groups do
        collection do
          post 'add_group'
          get 'group_list'
          post 'edit_group'
         end
      end

#NEW SOW
      resources :socials, only: [] do
        collection do
          post 'get_images'
        end
      end

   end
end
