class OrdersController < ApplicationController
    before_action :set_username 

    def create
        @order = Order.new
    end

    def new
        stockDet = Stock.find_by(product_name: params[:order][:stock_id])
        if stockDet.nil?
            flash.alert = "Stock does not exist"
            redirect_to orders_create_path(stock_hint: params[:order][:stock_id], quantity_hint: params[:order][:quantity], 
                flat_hint: params[:order][:flat_num], area_hint: params[:order][:area], city_hint: params[:order][:city], 
                state_hint: params[:order][:state], pincode_hint: params[:order][:pincode])
        else
            @stock_id = stockDet.id
            @quantity = params[:order][:quantity]
            @orderAmount = 0
            order_num = Time.now.strftime("%m%d%H%M%S")
            current_date = Time.now.strftime("%d-%m-%y")
            address = "#{params[:order][:flat_num]}, #{params[:order][:area]}, #{params[:order][:city]}, #{params[:order][:state]}, #{params[:order][:pincode]}"           
    
            if amount_cal
                flash.alert = "Quantity not available"
                redirect_to orders_create_path(stock_hint: params[:order][:stock_id], quantity_hint: params[:order][:quantity], 
                    flat_hint: params[:order][:flat_num], area_hint: params[:order][:area], city_hint: params[:order][:city], 
                    state_hint: params[:order][:state], pincode_hint: params[:order][:pincode])
            else
                @order = Order.new(order_number: "#{order_num}", stock_id: "#{@stock_id}", quantity: @quantity.to_i, user_id: @user_id, 
                    order_date: "#{current_date}", status: "In transit", total_amount: @orderAmount, address: "#{address}", deliCount: 0, orderType: "Supply")
                if @order.save 
                    stock_data = Stock.find_by(id: @stock_id)
                    stock_quant = stock_data.quantity
                    redirect_to orders_track_path, notice: "Order created successfully"
                    stockDet.update(quantity: stockDet.quantity-@quantity.to_i)
                else
                    redirect_to root_path, alert: "Unable to create order"
                end
            end
        end
    end

    def track
        @orders = Order.where(user_id: @user_id)
        @orders.each do |ord|
            if (ord.orderType == "Order" and ord.status=="Delivered" and ord.deliCount==0)
                stock = Stock.find_by(id: ord.stock_id)
                quant = stock.quantity
                stock.update(quantity: quant+ord.quantity)
                ord.update(deliCount: 1)
            elsif (ord.orderType == "Shipment" and ord.status=="Delivered" and ord.deliCount==0)
                prod_name = Stock.find_by(id: ord.stock_id).product_name
                stockData = Stock.find_by(product_name: "#{prod_name}", warehouse: ord.address)
                quant = stockData.quantity
                ord.update(deliCount: 1)
                stockData.update(quantity: quant+ord.quantity)
            end
        end
    end

    def cancel_order
        order_id = params[:order_id]
        order_data = Order.find_by(id: order_id)
        order_data.update(status: "Cancelled")
        stock_data = Stock.find_by(id: order_data.stock_id)
        stock_data.update(quantity: stock_data.quantity + order_data.quantity)
        redirect_to orders_track_path, notice: "Order cancelled"
    end

    def ship
        @quantity = params[:quantity]
        @stock_id = params[:ship_product_id]
        @warehouseName = params[:warehouse_name]
        if amount_cal
            redirect_to root_path, alert: "Quantity not available"
        elsif (Stock.find_by(id: @stock_id).warehouse == "Warehouse #{@warehouseName}")
            redirect_to root_path, alert: "Enter another warehouse"
        else
            shipment
            redirect_to root_path, notice: "Item shipped"
        end
    end

    def make
        @quantity = params[:quantity]
        @stock_id = params[:order_product_id]
        @supplierName = params[:supplier]
        if amount_cal
            redirect_to root_path, alert: "Quantity not available"
        else
            makeOrder
        end
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

        def shipment
            dataStock = Stock.find_by(id: @stock_id)
            nameStock = dataStock.product_name
            quantminus = dataStock.quantity
            stockData = Stock.find_by(product_name: "#{nameStock}", warehouse: "Warehouse #{@warehouseName}")
            order_num = Time.now.strftime("%m%d%H%M%S")
            current_date = Time.now.strftime("%d-%m-%y")
            order = Order.new(order_number: "#{order_num}", stock_id: "#{@stock_id}", quantity: @quantity.to_i, user_id: @user_id, 
                order_date: "#{current_date}", status: "In transit", total_amount: "#{dataStock.price}", address: "Warehouse #{@warehouseName}", deliCount: 0, orderType: "Shipment")
            order.save
            if stockData.nil?
                prod_cat = dataStock.category
                prod_price = dataStock.price
                stock = Stock.new(product_name: "#{nameStock}", category: "#{prod_cat}", quantity: 0, price: prod_price, warehouse: "Warehouse #{@warehouseName}")
                stock.save
            end
            dataStock.update(quantity: quantminus-@quantity.to_i)
        end

        def makeOrder
            dataStock = Stock.find_by(id: @stock_id)
            nameStock = dataStock.product_name
            quantminus = dataStock.quantity
            order_num = Time.now.strftime("%m%d%H%M%S")
            current_date = Time.now.strftime("%d-%m-%y")
            order = Order.new(order_number: "#{order_num}", stock_id: "#{@stock_id}", quantity: @quantity.to_i, user_id: @user_id, 
                order_date: "#{current_date}", status: "In transit", total_amount: dataStock.price*@quantity.to_i, address: "#{@supplierName}", deliCount: 0, orderType: "Order")
            order.save
            redirect_to orders_track_path, notice: "#{nameStock} Ordered"
        end
end
