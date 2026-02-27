class SimplifyPromptsForBundles < ActiveRecord::Migration[8.0]
  def change
    if foreign_key_exists?(:prompts, :users)
      remove_foreign_key :prompts, :users
    end

    remove_index :prompts, :category if index_exists?(:prompts, :category)

    if column_exists?(:prompts, :user_id)
      remove_column :prompts, :user_id
    end

    remove_column :prompts, :description if column_exists?(:prompts, :description)
    remove_column :prompts, :price if column_exists?(:prompts, :price)
    remove_column :prompts, :category if column_exists?(:prompts, :category)
  end
end

