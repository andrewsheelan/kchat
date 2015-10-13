class HomeController < ApplicationController
  protect_from_forgery :except => :presence_auth # stop rails CSRF protection for this action
  def index
    @chats = Chat.limit(100)
  end

	def presence_auth
		if current_user
		  user_id = current_user.id
		  user_email = current_user.email
			response = Pusher[params[:channel_name]].authenticate(
				params[:socket_id], {
				:user_id => user_id,
				:user_info => {
					:email => user_email
				}
			})

			render :json => response
		else
			render :text => "forbidden", :status => '403'
	  end
	end
end
