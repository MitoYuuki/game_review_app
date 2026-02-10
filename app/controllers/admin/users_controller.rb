# frozen_string_literal: true

# app/controllers/admin/users_controller.rb
class Admin::UsersController < Admin::BaseController
  before_action :authenticate_admin!
  layout "admin"

  def index
    @users = User.all.order(created_at: :asc)
    @users = User.where.not(email: "guest@example.com")
                  .order(created_at: :asc)
                  .page(params[:page])
                  .per(10)
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
