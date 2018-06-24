class Ability
  include CanCan::Ability
  def initialize(current_admin_user)
    can :access, :rails_admin
    can :dashboard  
    can :manage, User   
    can :read, AdminUser
    can :create, AdminUser
    can :update, AdminUser do |user|
	    (user.try(:email) == current_admin_user.email)
    end
    can :manage, StaticContentManagement 
  end
end

