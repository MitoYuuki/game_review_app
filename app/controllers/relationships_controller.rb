class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js   # create.js.erb を呼ぶ
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js   # destroy.js.erb を呼ぶ
    end
  end
end
