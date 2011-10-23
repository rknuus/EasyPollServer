class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :poll_id
      t.string :text
      t.string :kind

      t.timestamps
    end
  end
end
