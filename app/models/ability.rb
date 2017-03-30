class Ability
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  include CanCan::Ability

  def initialize(user)
    
    user ||= User.new # guest user (not logged in)
    
    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :add_user, :remove_user, to: :update_user
    
    # Group access from organization
    
    # If the user is in an org, they can view their org's groups
    can :read, Group, organization_id: user.organization.id
    # And can add of remove self from group in their org
    can :update_user, Group, organization_id: user.organization.id
    
    # If User has global group_creator, can read :new action and create Groups
    if user.has_role? :group_creator
      can :create, Group
      # This would enable only reading of Group new action!
      #can :read, Group.new
      can :read, Group.new
    end
    
    # Group instance roles
    # can :manage, Group, :id => user.roles.where(name: "creator", resource_type: "Group").pluck(:resource_id)
    # can :crud, Group, :id => user.roles.where(name: "admin", resource_type: "Group").pluck(:resource_id)
    
    # # Self Group add roles
    # can :update_users, Group, :id => user.roles.where(name: "admin", resource_type: "Group").pluck(:resource_id)
    # can :remove_users, Group, :id => user.roles.where(name: "tech", resource_type: "Group").pluck(:resource_id)
    # can :remove_users, Group, :id => user.roles.where(name: "default_role", resource_type: "Group").pluck(:resource_id)
    
    # # can :manage, Animal, group: { group_id: user.roles.where(name: "creator", resource_type: "Group").pluck(:resource_id) }
    # can :manage, Animal do |animal|
    #   user.roles.where(name: "creator", resource_type: "Group").pluck(:resource_id).include? animal.group_id
    # end
    # can :crud, Animal, :id => user.roles.where(name: "admin", resource_type: "Group").pluck(:resource_id)
    # can :crud, Animal, :id => user.roles.where(name: "tech", resource_type: "Group").pluck(:resource_id)
    # can :read, Animal, :id => user.roles.where(name: "default_role", resource_type: "Group").pluck(:resource_id)
    
    # can :manage, Animal, :group_id => Organization.with_role(:creator, group).pluck(:id)
    # can :crud, Animal, :group_id => Group.with_role(:admin, user).pluck(:id)
    # can :crud, Animal, :group_id => Group.with_role(:tech, user).pluck(:id)
    # can :read, Animal, :group_id => Group.with_role(:default_role, user).pluck(:id)
    
    
    # can :create, User, membership: {group: {CONDITION_ON_GROUP} }
    
    unless user.groups.empty?
      user.groups.each do |group|
        if user.has_role?(:creator, group)
          # User can :manage his own group including all unique controller actions
          #can :manage, Group, owner_id: user.id
          can :manage, group
          can :manage, Animal, :group_id => group.id
          can :manage, Animal, :group_id => nil
          can :manage, Cage, :group_id => group.id
          can :manage, Cage, :group_id => nil
          can :scanner, Group, :group_id => group.id
        elsif user.has_role?(:admin, group)
          # User can use standard controller actions and update the users in group
          #can :crud, Group, :id => Group.with_role(:admin, user).pluck(:id)
          can :crud, group
          can :update_users, group
          can :manage, Animal, :group_id => group.id

          can :manage, Cage, :group_id => group.id
        elsif user.has_role?(:tech, group)
          can :crud, Animal, :group_id => group.id
          can :crud, Cage, :group_id => group.id
        elsif user.has_role?(:default_role, group)
          # User can only remove themselves from group
          can :remove_user, group
          can :read, Animal, :group_id => group.id
          can :read, Cage, :group_id => group.id
        end
        
        if group.has_role?(:admin, user.organization)
          can :manage, Group, :organization => { :id => user.organization.id }
          can :create, Group
          can :manage, Animal, :group => { :organization_id => user.organization.id }
          can :manage, Cage, :group => { :organization_id => user.organization.id }
          can :update_user, Organization, :id => user.organization.id
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
      can :update_user, Organization, :id => Organization.with_role(:admin, user).pluck(:id)
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
  #     can :manage, Animal, :organization_id => Organization.pluck(:id)
  #   elsif group.has_role? :vet
  #     can :manage, Animal, :organization_id => Organization.pluck(:id)
  #   else
  #     can :read, Animal, :group_id => Group.pluck(:id)
  #   end
  # end


  
end
