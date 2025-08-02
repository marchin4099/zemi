class AddBodyToTweets < ActiveRecord::Migration[7.1]
  def change
    add_column :tweets, :body, :text
  end
end
