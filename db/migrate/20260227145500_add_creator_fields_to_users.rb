class AddCreatorFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :country, :string, null: false, default: ""
    add_column :users, :profile_description, :text
    add_column :users, :years_of_experience, :integer
    add_column :users, :rating, :decimal, null: false, default: 0.0, precision: 3, scale: 2
    add_column :users, :total_reviews, :integer, null: false, default: 0

    change_column_default :users, :country, from: "", to: nil
  end
end

