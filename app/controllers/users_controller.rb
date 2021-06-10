class UsersController < ApplicationController
  def new #automatically call new.html
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create #handle signup failure
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!" #display temporary message
      redirect_to @user #redirect to user_url(@user)
    else
      render 'new' #rerender if invalid infomation
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
