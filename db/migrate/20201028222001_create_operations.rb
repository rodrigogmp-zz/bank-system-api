class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.references :account, foreign_key: true
      t.integer :operation
      t.float :value
      t.integer :account_id_to_transfer, foreign_key: true
      t.timestamps
    end
  end
end
