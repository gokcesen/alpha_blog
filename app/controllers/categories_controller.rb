class CategoriesController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = "Category was successfully created"
          redirect_to @category
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = "Invalid category"
          render turbo_stream: turbo_stream.replace("flash-messages", partial: "shared/flash")
        end
        format.html do
          render :new, status: :unprocessable_entity
        end
      end
    end
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 3)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:notice] = "Category name updated successfully"
      redirect_to @category
    else
      render 'edit'
    end
  end

  def show
    @category = Category.find(params[:id])  # Kategori id'si ile kategori bul
    @articles = @category.articles.paginate(page: params[:page], per_page: 5) 
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    unless (logged_in? && current_user.admin?)
      flash[:alert] = "Only admins can perform that action"
      redirect_to categories_path
    end
  end
end
