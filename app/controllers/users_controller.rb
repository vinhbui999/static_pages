class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index #all users, users_path
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end

  def new #automatically call new.html
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create #handle signup failure
    @user = User.new(user_params)
    if @user.save
      log_in @user #automatically login after signup
      flash[:success] = "Welcome to the Sample App!" #display temporary message
      redirect_to @user #redirect to user_url(@user)
    else
      render 'new' #rerender if invalid infomation
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find_by(params[:id])
    if @user.update(user_params)
      flash[:success] = "Updated!!!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #before filter
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in !!!"
      redirect_to login_path
    end
  end

  #Confirm correct user to edit their profile
  def correct_user
    @user = User.find_by(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  #only admin can delete
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
