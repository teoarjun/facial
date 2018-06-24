require Rails.root.join('lib', 'rails_admin', 'impersonate_user.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ImpersonateUser)
RailsAdmin.config do |config|
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin_user
  end
  config.current_user_method(&:current_admin_user)

  ## == Cancan ==
  config.authorize_with :cancan

  config.model  'AdminUser' do      
    list do
      field :name do
        filterable false
        searchable true
      end
      field :email do
        filterable false
        searchable false
      end
      field :image do
        filterable false
        searchable false
      end
    end
    edit do 
      field :name  do
        html_attributes do
          {:maxlength => 30}
        end
      end     
      field :email do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :password do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :password_confirmation do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :image,:carrierwave
    end
    show do
      field :name
      field :email
      field :image
    end
    create do 
      field :name  do
        html_attributes do
          {:maxlength => 30}
        end
      end     
      field :email do
        html_attributes do
          {:maxlength => 60}
        end
      end
      field :password do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :password_confirmation do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :image,:carrierwave
    end
    show do
      field :name
      field :email
      field :image
    end
  end

  config.model 'User' do      
    list do
      items_per_page 50
      field :name do
        filterable false
        searchable true
        label "User Name"
      end
      field :email do 
        searchable false
        filterable false
      end
      
      field "Stories" do 
        pretty_value do 
           bindings[:view].link_to(bindings[:object].stories.count)
        end
      end

      field "Country" do 
        pretty_value do 
           bindings[:object].country
        end
      end
      
      field :dob do 
        searchable false
        filterable false
      end
      field :gender do
        searchable false
        filterable false
      end 
      field :last_sign_in_at do
        label "Last Activity"
        searchable false
        filterable false
      end  
      field :activate do
        label "User Status"
        filterable false
        searchable false
        pretty_value do
          bindings[:object].activate? ? "Unblock" : "Block"
        end
      end
    end
    
    show do
      field :email
      field :name
      field :address
      field :image
      field :dob
      field :bio
      field :noti_type 
      
      field :stories do
        formatted_value do
          pretty_value do
            bindings[:object].stories.count
          end
        end
      end

      field :country do 
       formatted_value do
          pretty_value do
            bindings[:object].country
          end
        end
      end


      field :activate do
        label "User Status"
        pretty_value do
          bindings[:object].activate? ? "Unblock" : "Block"
        end
      end
    end
    
    edit do        
      field :email do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :password do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :password_confirmation do
        label "Password Confirmation"
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :name do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :gender, :enum do
       partial :gender
      end   
      field :address do
        html_attributes do
          {:maxlength => 30}
        end
      end
      field :dob do
        partial :dob 
      end
      field :bio do
        html_attributes do
          {:maxlength => 600}
        end
      end
    end
  end

  config.model 'StaticContentManagement' do      
    list do
      field :title do 
        filterable false
      end
      field :content do
        filterable false
        pretty_value do
          value.truncate(50, :separator => ' ').html_safe # used in exports, where no html/data is allowed
        end
      end
    end
    show do
      field :title
      field :content do
        formatted_value do
          value.to_s.html_safe
        end
      end
    end
    edit do        
      field :title do
        read_only true
      end
      field :content, :ck_editor do
        required true
        html_attributes do
       {:maxlength => 600} #dont use 600 as maxlength for a string field. It will break the UI
      end
      end
    end
  end



  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except StaticContentManagement
    end 
    show
    edit do
      except User
    end 
    impersonate_user  do
      only User
    end 
  end


end
