class OrdersController < ApplicationController
    before_action :set_username 

    def create
        @order = Order.new
    end

    def new
        @stock_id = Stock.find_by(product_name: params[:order][:stock_id]).id
        @quantity = params[:order][:quantity]
        @orderAmount = 0
        order_num = Time.now.strftime("%m%d%H%M%S")
        current_date = Time.now.strftime("%d-%m-%y")
        address = "#{params[:order][:flat_num]}, #{params[:order][:area]}, #{params[:order][:city]}, #{params[:order][:state]}, #{params[:order][:pincode]}"
        if !Stock.exists?(@stock_id)
            flash.alert = "Stock does not exist"
            redirect_to orders_create_path(stock_hint: params[:order][:stock_id], quantity_hint: params[:order][:quantity], 
                flat_hint: params[:order][:flat_num], area_hint: params[:order][:area], city_hint: params[:order][:city], 
                state_hint: params[:order][:state], pincode_hint: params[:order][:pincode])

        elsif amount_cal
            flash.alert = "Quantity not available"
            redirect_to orders_create_path(stock_hint: params[:order][:stock_id], quantity_hint: params[:order][:quantity], 
                flat_hint: params[:order][:flat_num], area_hint: params[:order][:area], city_hint: params[:order][:city], 
                state_hint: params[:order][:state], pincode_hint: params[:order][:pincode])
        else
            @order = Order.new(order_number: "#{order_num}", stock_id: "#{@stock_id}", quantity: @quantity.to_i, user_id: @user_id, 
                order_date: "#{current_date}", status: "In transit", total_amount: @orderAmount, address: "#{address}")
            if @order.save 
                stock_data = Stock.find_by(id: @stock_id)
                stock_quant = stock_data.quantity
                stock_data.update(quantity: stock_quant-@quantity.to_i)
                redirect_to orders_track_path, notice: "Order created successfully"
            else
                redirect_to root_path, alert: "Unable to create order"
            end
        end
    end

    def track
        @orders = Order.where(user_id: @user_id)
    end

    def cancel_order
        order_id = params[:order_id]
        order_data = Order.find_by(id: order_id)
        order_data.destroy
        redirect_to orders_track_path, notice: "Order cancelled"
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
            @orderAmount = stockPrice*@quantity.to_i
            return stockQuant < @quantity.to_i 
        end
end
