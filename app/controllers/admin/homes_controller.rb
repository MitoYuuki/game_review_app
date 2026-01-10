# frozen_string_literal: true

class Admin::HomesController < Admin::BaseController
  # authenticate_admin! と layout は BaseController にあるので不要
  def top
    # 管理者ログイン後のトップページ
  end
end
