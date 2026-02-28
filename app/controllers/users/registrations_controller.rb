# frozen_string_literal: true

# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  before_action :reject_guest_user, only: [:edit, :update, :destroy, :edit_account, :update_account]

  # --------------------------------------------------
  # アカウント編集画面
  # --------------------------------------------------
  def edit_account
    self.resource = current_user
    render :edit
  end

  # --------------------------------------------------
  # アカウント更新（current_password 必須）
  # --------------------------------------------------
  def update_account
    self.resource = current_user

    if resource.update_with_password(account_update_params)
      # パスワード変更時もログイン維持
      bypass_sign_in(resource)
      set_flash_message(:notice, :updated)
      redirect_to edit_account_path
    else
      render :edit
    end
  end

  # --------------------------------------------------
  # 退会処理
  # --------------------------------------------------
  def destroy
    if current_user.guest?
      redirect_to root_path, alert: "ゲストユーザーは退会できません"
    else
      super
    end
  end

  private

  # --------------------------------------------------
  # ゲストユーザー制御
  # --------------------------------------------------
  def reject_guest_user
    if current_user&.guest?
      redirect_to root_path, alert: "ゲストユーザーはこの操作はできません"
    end
  end

  protected

  # アップデート後のリダイレクト先
  def after_update_path_for(resource)
    edit_account_path
  end

  # サインアウト後のリダイレクト先
  def after_sign_out_path_for(resource_or_scope)
    new_user_registration_path
  end
end