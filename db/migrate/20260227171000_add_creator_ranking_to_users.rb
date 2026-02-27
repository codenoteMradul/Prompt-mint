class AddCreatorRankingToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :ranking_score, :float, null: false, default: 0.0
    add_column :users, :rank_position, :integer
    add_index :users, :ranking_score
    add_index :users, :rank_position
  end
end

