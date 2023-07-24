class SuppliersController < ApplicationController
    before_action :set_username
    def info
       @supps = Supplier.all() 
    end

    private
        def set_username
            @user_id = Current.user.id
            user = User.find_by(id: @user_id)
            @username = user.username
        end
end
