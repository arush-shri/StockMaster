class OrdersController < ApplicationController
    before_action :set_username 

    def create
        @order = Order.new
    end

    def new
        @stock_id = params[:order][:stock_id]
        @quantity = params[:order][:quantity]
        address = "#{params[:order][:flat_num]}, #{params[:order][:area]}, #{params[:order][:city]}, #{params[:order][:state]}, #{params[:order][:pincode]}"
        if !Stock.exists?(@stock_id)
            flash.alert = "Stock does not exist"
            redirect_to orders_create_path(stock_hint: params[:order][:stock_id], quantity_hint: params[:order][:quantity], 
                flat_hint: params[:order][:flat_num], area_hint: params[:order][:area], city_hint: params[:order][:city], 
                state_hint: params[:order][:state], pincode_hint: params[:order][:pincode])
            puts "false"
        else
            puts "true"
            amount_cal
        end
        @stockAmount = 0
        current_datetime = Time.now.strftime("%m%d%H%M%S")
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
            params.permit(:stock_id, :quantity, :flat_num, :area, :city, :state, :pincode)
        end

        def amount_cal
            stockData = Stock.find_by(id: @stock_id)
            stockPrice = stockData.price
            stockQuant = stockData.quantity
            if(stockQuant < @quantity.to_i)
                flash.alert = "Quantity not available"
                redirect_to orders_create_path(stock_hint: params[:order][:stock_id], quantity_hint: params[:order][:quantity], 
                    flat_hint: params[:order][:flat_num], area_hint: params[:order][:area], city_hint: params[:order][:city], 
                    state_hint: params[:order][:state], pincode_hint: params[:order][:pincode])
            end
            @stockAmount = stockPrice*@quantity.to_i
        end
end
