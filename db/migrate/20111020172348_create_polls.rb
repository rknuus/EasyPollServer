class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title
      t.datetime :published_at
      t.datetime :closed_at

      t.timestamps
    end
  end
end
