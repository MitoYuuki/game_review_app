class Users::RegistrationsController < Devise::RegistrationsController
  
   # アカウント編集画面
  def edit_account
    self.resource = current_user
    render :edit
  end

  # アカウント更新（current_password 必須）
  def update_account
    self.resource = current_user

    if resource.update_with_password(account_update_params)
      bypass_sign_in(resource)
      set_flash_message(:notice, :updated)
      redirect_to edit_account_path
    else
      render :edit
    end
  end

  def destroy
    if resource.guest?
      redirect_to root_path, alert: "ゲストユーザーは退会できません"
    else
      super
    end
  end

  protected

  def after_update_path_for(resource)
    edit_account_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_registration_path
  end
end