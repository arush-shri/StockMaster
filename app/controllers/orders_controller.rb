class OrdersController < ApplicationController
    before_action :set_username 

    def create
        @order = Order.new
        @some = "Some"
    end

    def new
        # @order = Order.new(order_params)
        quantity = params[:order][:quantity]
        puts "Quantity: #{quantity}"
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

        def order_params
            params.require(:order).permit(:stock_id, :quantity, :flat_num, :area, :city, :state, :pincode)
        end
end
