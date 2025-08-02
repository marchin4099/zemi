class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :mail
      t.string :title
      t.text :about

      t.timestamps
    end
  end
end
