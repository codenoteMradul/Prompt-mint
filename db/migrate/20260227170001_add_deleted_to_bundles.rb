class AddDeletedToBundles < ActiveRecord::Migration[8.0]
  def change
    add_column :bundles, :deleted, :boolean, null: false, default: false
    add_index :bundles, :deleted
  end
end

