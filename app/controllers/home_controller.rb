class HomeController < ApplicationController
  def index
    @user = User.last.username
  end
end
