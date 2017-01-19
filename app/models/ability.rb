class Ability
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    
    alias_action :create, :read, :update, :destroy, to: :crud
    
    if user.has_role? :group_creator
      can :create, Group
    elsif user.has_role?(:creator, Group)
      can :manage, Group, owner_id: user.id
    elsif user.has_role?(:admin, Group)
      can :crud, Group, :id => Group.with_role(:admin, user).pluck(:id)
    else
      can :read, Group
    end
    
    if user.has_role? :organization_creator
      can :create, Organization
    # elsif user.has_role?(:creator, Organization)
    #   can :manage, Organization, owner_id: user.id
    # elsif user.has_role?(:admin, Organization)
    #   can :crud, Organization, :id => Organization.with_role(:admin, user).pluck(:id)
    # else
    #   can :read, Organization
    end
  end
  
  def initialize(group)
    user ||= Group.new # guest group??
    
    alias_action :create, :read, :update, :destroy, to: :crud
    
    if group.has_role? :admin
      # can :read, Animal, within organization
    elsif group.has_role? :vet
      # can :read, Animal, within organization
    else
      # can :read, Animal, within group
    end
  end
  # Define abilities for the passed in user here. For example:
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
