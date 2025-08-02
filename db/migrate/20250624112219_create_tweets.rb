class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.string :name
      t.text :about
      t.text :day
      t.string :place

      t.timestamps
    end
  end
end
