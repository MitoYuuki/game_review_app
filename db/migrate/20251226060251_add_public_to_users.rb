class AddPublicToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :public, :boolean, default: true, null: false
  end
end
