class FixOwnerName < ActiveRecord::Migration
  def change
    rename_column :days, :user_id, :user_id
  end
end
