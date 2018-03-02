class CreateItems < ActiveRecord::Migration
  def up
    create_table :items do |t|
      t.string :name
      t.string :amount
      t.integer :user_id
    end
  end

  def down
    drop_table :items
  end
end
