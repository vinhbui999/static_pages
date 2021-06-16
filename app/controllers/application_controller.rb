class ApplicationController < ActionController::Base
    include SessionsHelper
    def hello
        render html: "hello, world"
    end
    #Confirm a logged_in_user
    def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in !!!"
          redirect_to login_path
        end
    end
end
