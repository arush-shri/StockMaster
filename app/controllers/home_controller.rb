class HomeController < ApplicationController
  def index
    user_id = Current.user.id
    user = User.find_by(id: user_id)
    @username = user.username
  end
end
