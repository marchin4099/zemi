class AddUserIdToContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :user_id, :integer
  end
end
