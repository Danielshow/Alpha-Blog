class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  def new
    @user = User.new
  end

  def index 
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Welcome to AlphaBlog #{@user.username}"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit; end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = 'Users and all articles has been deleted'
    redirect_to users_path
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Your credentials was updated successfully'
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 3)
  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :about)
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:notice] = 'You cannot perform this operation'
      redirect_to root_path
    end
  end

  def require_admin
    unless current_user.admin?
      flash[:notice] = 'Only admin can perform that action'
      redirect_to root_path
    end
  end
end