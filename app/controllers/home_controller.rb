class HomeController < ApplicationController

  before_action :set_username 
  def index
    @stock = Stock.all
    supps = Supplier.all
    @suppList = supps.map(&:supplier_name)
  end

  private
    def set_username
      user_id = Current.user.id
      user = User.find_by(id: user_id)
      @username = user.username
    end
end
