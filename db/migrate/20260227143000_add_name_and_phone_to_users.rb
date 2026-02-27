class AddNameAndPhoneToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :phone, :string, null: false, default: ""

    change_column_default :users, :name, from: "", to: nil
    change_column_default :users, :phone, from: "", to: nil
  end
end

