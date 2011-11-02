class AddCategoryToPoll < ActiveRecord::Migration
  def change
    add_column :polls, :category, :string
  end
end
