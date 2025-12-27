class RenamePublicToIsPublicInUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :public, :is_public
  end
end
