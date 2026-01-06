class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])

    # そのカテゴリに属するコミュニティだけ取得
    @communities = Community.where(category_id: @category.id)
  end
end

