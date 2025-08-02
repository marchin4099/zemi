class AddImageToStudents < ActiveRecord::Migration[7.1]
  def change
    add_column :students, :image, :string
  end
end
