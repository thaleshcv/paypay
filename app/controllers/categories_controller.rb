# frozen_string_literal: true

# Controller for category resource.
class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = policy_scope(Category).order(user_id: :desc, name: :asc)
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to categories_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity, notice: t(".fail")
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity, notice: t(".success")
    end
  end

  def destroy
    @category.discard!
    redirect_to categories_path, notice: t(".success")
  end

  private

  def set_category
    @category = authorize(
      policy_scope(Category).find_by!(token: params[:id])
    )
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
