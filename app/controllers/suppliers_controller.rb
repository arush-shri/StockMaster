class SuppliersController < ApplicationController
    before_action :set_username
    def info
       @supps = Supplier.all() 
    end
    def new
        @supplier = Supplier.new
    end
    def create
        @supplier_name = params[:supplier][:supplier_name]
        @supplier_email = params[:supplier][:supplier_email]
        @supplier_phone = params[:supplier][:phone_num]
        @supplier_address = "#{params[:supplier][:flat_num]}, #{params[:supplier][:area]}, #{params[:supplier][:city]}, #{params[:supplier][:state]}, #{params[:supplier][:pincode]}"
        create_supplier
    end

    private
        def set_username
            @user_id = Current.user.id
            user = User.find_by(id: @user_id)
            @username = user.username
        end

        def create_supplier
            @supps = Supplier.new(supplier_name: "#{@supplier_name}", email: "#{@supplier_email}", phone: "#{@supplier_phone}", address: "#{@supplier_address}")
            if @supps.save 
                redirect_to suppliers_info_path, notice: "Supplier added successfully"
            else
                redirect_to suppliers_new_path(name_hint: params[:supplier][:supplier_name], email_hint: params[:supplier][:supplier_email],
                    phone_hint: params[:supplier][:phone_num],flat_hint: params[:order][:flat_num], area_hint: params[:order][:area], 
                    city_hint: params[:order][:city], state_hint: params[:order][:state], pincode_hint: params[:order][:pincode]), alert: "Unable to add supplier"
            end
        end

end
