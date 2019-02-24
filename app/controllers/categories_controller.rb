class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :create, :destroy, :edit, :update]
  before_action :require_admin, except: [:index, :show]

  def index
    @categories = Category.paginate(page: params[:page], per_page: 7);
  end

  def new
    @category = Category.new
  end
  
  def show; end 

  def edit; end

  def update
    if @category.update(category_params)
      flash[:notice] = 'Category was updated successfully'
      redirect_to category_path(@category)
    else
      render 'edit'
    end
  end

  def create
    if @category.save
      flash[:notice] = 'category was created successfully'
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = 'Category was successfully deleted'
    redirect_to categories_path
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    if !logged_in? || (!logged_in? && !current_user.admin?)
      flash[:notice] = 'You are not authorized to do this'
      redirect_to categories_path
    end
  end
end