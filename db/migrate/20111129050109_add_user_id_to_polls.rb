class AddUserIdToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :user_id, :integer
  end
end
