class AccountActivationsController < ApplicationController

    def edit
        user = User.find_by(email: params[:email].downcase)
        if user && !user.activated? && user.authenticated?(:activation, params[:id])
            user.activate
            log_in user
            flash[:success] = "Account Activated!!!"
            redirect_to user
        else
            puts user.authenticated?(:activation, params[:id])
            flash[:danger] = "Invalid activation link!"
            redirect_to root_path
        end
    end
end
