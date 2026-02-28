# frozen_string_literal: true

class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])

    # そのカテゴリに属するコミュニティだけ取得
    @communities = @category.communities
  end
end
