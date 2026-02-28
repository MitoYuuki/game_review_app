# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: :show

  def index
    @groups = Group.all.order(:name)
  end

  def show
    @posts = @group.posts.order(created_at: :desc)
  end

  private

    def set_group
      @group = Group.find(params[:id])
    end
end
