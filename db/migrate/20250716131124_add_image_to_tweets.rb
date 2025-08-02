class AddImageToTweets < ActiveRecord::Migration[7.1]
  def change
    add_column :tweets, :image, :string
  end
end
