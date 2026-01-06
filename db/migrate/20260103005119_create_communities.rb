class CreateCommunities < ActiveRecord::Migration[6.1]
  def change
    create_table :communities do |t|
      t.string :name, null: false
      t.text :description
      t.integer :owner_id, null: false
      t.boolean :is_public, null: false, default: true

      t.timestamps
    end

    add_index :communities, :owner_id
  end
end

