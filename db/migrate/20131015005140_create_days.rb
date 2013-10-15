class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :date
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
