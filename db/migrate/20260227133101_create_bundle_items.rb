class CreateBundleItems < ActiveRecord::Migration[8.0]
  def change
    create_table :bundle_items do |t|
      t.references :bundle, null: false, foreign_key: true
      t.references :prompt, null: false, foreign_key: true

      t.timestamps
    end

    add_index :bundle_items, [ :bundle_id, :prompt_id ], unique: true
  end
end

