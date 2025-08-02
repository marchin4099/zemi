class AddDateToLetters < ActiveRecord::Migration[7.1]
  def change
    add_column :letters, :day, :date
  end
end
