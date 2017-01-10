class InvitesController < ApplicationController
  def create
    @invite = Invite.new(invite_params)
    @invite.sender_id = current_user.id
    if @invite.save
  
      #if the user already exists
      if @invite.recipient != nil 
  
         #send a notification email
         InviteMailer.existing_user_invite(@invite).deliver 
  
         #Add the user to the user group
         @invite.recipient.user_groups.push(@invite.group_membership)
      else
         InviteMailer.new_user_invite(@invite, new_user_registration_url(:invite_token => @invite.token)).deliver
      end
    else
       # oh no, creating an new invitation failed
    end
  end
end
