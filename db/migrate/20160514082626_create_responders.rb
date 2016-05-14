class CreateResponders < ActiveRecord::Migration
  def change
    create_table :responders do |t|
      t.string :type
      t.string :name
      t.boolean :dispatch, default: false
      t.integer :capacity

      t.timestamps null: false
    end
  end
end
