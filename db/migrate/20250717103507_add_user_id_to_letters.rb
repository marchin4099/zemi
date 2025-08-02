class AddUserIdToLetters < ActiveRecord::Migration[7.1]
  def change
    add_column :letters, :user_id, :integer
  end
end
