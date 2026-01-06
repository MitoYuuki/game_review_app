class AddCategoryIdToCommunities < ActiveRecord::Migration[6.1]
  def change
    add_column :communities, :category_id, :integer
  end
end
