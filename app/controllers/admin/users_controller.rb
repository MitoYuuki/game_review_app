# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_user, only: [:show, :destroy]
  layout "admin"

  def index
    @users = User.where.not(id: User.guest.id)
                 .order(created_at: :asc)
                 .page(params[:page])
                 .per(10)
  end


  def show
    
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "ユーザーを退会させました"
    else
      redirect_to admin_users_path, alert: "ユーザーを削除できませんでした"
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
