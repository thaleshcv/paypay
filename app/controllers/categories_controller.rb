# frozen_string_literal: true

# Controller for category resource.
class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index; end

  def new; end

  def create
    @category = current_user.categories.build(category_params)

    if @category.save
      redirect_to categories_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def set_category
    @category = authorize(current_user.categories.find_by!(token: params[:id]))
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
