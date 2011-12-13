class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :participation_id
      t.integer :option_id

      t.timestamps
    end
  end
end
