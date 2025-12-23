# app/controllers/admin/users_controller.rb
class Admin::UsersController < Admin::BaseController
  before_action :authenticate_admin!
  layout "admin"

  def index
    @users = User.all.order(created_at: :asc)
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path, notice: "ユーザーを退会させました"
  end
end
