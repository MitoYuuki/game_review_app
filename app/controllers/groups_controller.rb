class GroupsController < ApplicationController
  def index
    @groups = Group.all.order(:name)
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.order(created_at: :desc)
  end
end
