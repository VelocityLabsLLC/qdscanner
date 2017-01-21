class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    
    alias_action :create, :read, :update, :destroy, to: :crud
    
    if user.groups.empty?
      if user.has_role? :group_creator
        can :create, Group
        # This would enable only reading of Group new action!
        #can :read, Group.new
        can :read, Group.new
      end
    else
      user.groups.each do |group|
        if user.has_role?(:creator, group)
          # Manage his own group
          can :manage, Group, owner_id: user.id
          # Can read other groups in the organization user is a part of
          can :read, Group, organization_id: user.organization.id
        elsif user.has_role?(:admin, group)
          can :crud, Group, :id => Group.with_role(:admin, user).pluck(:id)
          # Can read other groups in the organization user is a part of
          can :read, Group, organization_id: user.organization.id
        else
          can :read, Group, :id => user.groups.pluck(:id)
        end
      end
    end
    
    if user.has_role? :organization_creator
      can :create, Organization
      # This would enable only reading of Organization new action!
      #can :read, Organization.new
      can :read, Organization.new
    end
    
    if user.has_role?(:creator, user.organization)
      can :manage, Organization, owner_id: user.id
    elsif user.has_role?(:admin, user.organization)
      can :crud, Organization, :id => Organization.with_role(:admin, user).pluck(:id)
    else
      if user.organization
        can :read, Organization, :id => user.organization.id
      end
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
