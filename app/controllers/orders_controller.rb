class OrdersController < ApplicationController
    before_action :set_username 

    def create
    end

    def track
        @orders = Order.where(user_id: @user_id)
    end


    private
        def set_username
            @user_id = Current.user.id
            user = User.find_by(id: @user_id)
            @username = user.username
        end
end
