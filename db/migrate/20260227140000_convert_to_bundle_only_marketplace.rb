class ConvertToBundleOnlyMarketplace < ActiveRecord::Migration[8.0]
  def change
    add_reference :prompts, :bundle, foreign_key: true

    if foreign_key_exists?(:purchases, :prompts)
      remove_foreign_key :purchases, :prompts
    end

    if index_exists?(:purchases, [ :user_id, :prompt_id ])
      remove_index :purchases, column: [ :user_id, :prompt_id ]
    end

    add_reference :purchases, :bundle, foreign_key: true

    if column_exists?(:purchases, :prompt_id)
      remove_column :purchases, :prompt_id
    end

    add_index :purchases, [ :user_id, :bundle_id ], unique: true

    drop_table :bundle_items, if_exists: true do |t|
      t.references :bundle, null: false, foreign_key: true
      t.references :prompt, null: false, foreign_key: true
      t.timestamps
    end
  end
end

