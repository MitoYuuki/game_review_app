class UsersController < ApplicationController

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "ゲストログインしました"
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.role = :guest
    end
  end

end
