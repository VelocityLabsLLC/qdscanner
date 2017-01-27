class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :add_user, :remove_user, to: :update_users
    
    # If the user is in an org, they can view their org's groups
    if user.organization_id!=1
      can :read, Group, organization_id: user.organization.id
      can :add_user, Group, organization_id: user.organization.id
    else
      # Everyone not in an org sees unaffiliated Groups (actually in org 1 "None")
      can :read, Group, organization_id: 1
      can :add_user, Group, organization_id: 1
    end
    
    # If User has global group_creator, can read :new action and create Groups
    if user.has_role? :group_creator
      can :create, Group
      # This would enable only reading of Group new action!
      #can :read, Group.new
      can :read, Group.new
    end
    
    # Group instance roles
    
    # can :manage, Group, :id => Group.with_role(:creator, user).pluck(:id)
    # can :crud, Group, :id => Group.with_role(:admin, user).pluck(:id)
    # can :update_users, Group, :id => Group.with_role(:admin, user).pluck(:id)
    # can :remove_users, Group, :id => Group.with_role(:tech, user).pluck(:id)
    # can :remove_users, Group, :id => Group.with_role(:default_role, user).pluck(:id)
    
    # can :manage, Animal, :id => Group.with_role(:creator, user).pluck(:id)
    # can :crud, Animal, :id => Group.with_role(:admin, user).pluck(:id)
    # can :crud, Group, :id => Group.with_role(:tech, user).pluck(:id)
    # can :read, Group, :id => Group.with_role(:default_role, user).pluck(:id)
    
    unless user.groups.empty?
      user.groups.each do |group|
        if user.has_role?(:creator, group)
          # User can :manage his own group including all unique controller actions
          #can :manage, Group, owner_id: user.id
          can :manage, group
          can :manage, Animal, :group_id => group.id
        elsif user.has_role?(:admin, group)
          # User can use standard controller actions and update the users in group
          #can :crud, Group, :id => Group.with_role(:admin, user).pluck(:id)
          can :crud, group
          can :update_users, group
          can :manage, Animal, :group_id => group.id
        elsif user.has_role?(:tech, group)
          can :crud, Animal, :group_id => group.id
        elsif user.has_role?(:default_role, group)
          # User can only remove themselves from group
          can :remove_user, group
          can :read, Animal, :group_id => group.id
        end
      end
    end
    
    can :read, Organization
    if user.has_role? :organization_creator
      can :create, Organization
      # This would enable only reading of Organization new action!
      #can :read, Organization.new
    end
    
    if user.has_role?(:creator, user.organization)
      can :manage, Organization, owner_id: user.id
    elsif user.has_role?(:admin, user.organization)
      can :crud, Organization, :id => Organization.with_role(:admin, user).pluck(:id)
      can :add_user, Organization, :id => Organization.with_role(:admin, user).pluck(:id)
      can :remove_user, Organization, :id => Organization.with_role(:admin, user).pluck(:id)
    elsif user.has_role?(:default_role, user.organization)
      # can remove a user from organization if they have one
      can :remove_user, user.organization
    else
      #can :read, Organization #, :id => user.organization.id
      # can join an organization
      can :add_user, Organization
    end
    
  end
  
  # def initialize(group)
  #   user ||= Group.new # guest group??
    
  #   alias_action :create, :read, :update, :destroy, to: :crud
    
  #   if group.has_role? :admin
  #     # can :read, Animal, within organization
  #   elsif group.has_role? :vet
  #     # can :read, Animal, within organization
  #   else
  #     # can :read, Animal, within group
  #   end
  # end
  # # Define abilities for the passed in user here. For example:
  #
  #   user ||= User.new # guest user (not logged in)
  #   if user.admin?
  #     can :manage, :all
  #   else
  #     can :read, :all
  #   end
  #
  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, :published => true
  #
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  
end
