# frozen_string_literal: true

class TagsController < ApplicationController
  before_action :set_tag, only: :show

  def index
    @tags = Tag.all.order(:name)
  end

  def show
    @posts = @tag.posts.order(created_at: :desc)
  end

  private

    def set_tag
      @tag = Tag.find(params[:id])
    end
end
