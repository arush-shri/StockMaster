class HomeController < ApplicationController

  before_action :set_username 
  def index
    @stock = Stock.all
    supps = Supplier.all
    @suppList  = supps.map(&:supplier_name)
  end

  def new
    @name = params[:product_name]
    @quantity = params[:quantity]
    @category = params[:category]
    @price = params[:price]
    @supplier = params[:supplier]
    @warehouse = params[:warehouse]
    stock = Stock.find_by(product_name: "#{@name}", warehouse: "Warehouse #{@warehouse}")
    if stock.nil?
      create_product
    else
      redirect_to root_path, alert: "#{@name} already exists"
    end
  end
  private
    def set_username
      user_id = Current.user.id
      user = User.find_by(id: user_id)
      @username = user.username
    end

    def create_product
      stock = Stock.new(product_name: "#{@name}", category: "#{@category}", quantity: "#{@quantity}", price: "#{@price}", warehouse: "#{@warehouse}")
      if stock.save 
        redirect_to root_path, notice: "#{@name} added successfully"
      end
    end
end
