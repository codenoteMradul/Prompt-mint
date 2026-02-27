class CreatePrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :prompts do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :content, null: false
      t.integer :price, null: false
      t.integer :category, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :prompts, :category
  end
end

