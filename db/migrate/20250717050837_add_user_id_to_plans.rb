class AddUserIdToPlans < ActiveRecord::Migration[7.1]
  def change
    add_column :plans, :user_id, :integer
  end
end
