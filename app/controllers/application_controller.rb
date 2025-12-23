class ApplicationController < ActionController::Base
  # Deviseコントローラが呼ばれた場合、追加のパラメータを許可
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # ===========================
  # ログイン後の遷移先
  # ===========================
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_users_path   # 管理者はユーザー一覧ページへ
    else
      posts_path         # 通常ユーザーは投稿一覧へ
    end
  end

  # ===========================
  # ログアウト後の遷移先
  # ===========================
  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
    when :admin
      new_admin_session_path  # 管理者はログイン画面へ
    else
      root_path               # 通常ユーザーはトップページへ
    end
  end

  # ===========================
  # Devise 許可パラメータ
  # ===========================
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile])
  end

  # ===========================
  # ゲストユーザー制御
  # ===========================
  def reject_guest_user
    return if current_user.present?

    flash[:alert] = "この操作をするにはログインが必要です"
    redirect_to new_user_session_path
  end
end
