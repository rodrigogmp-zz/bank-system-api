class AddIndexToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_index :accounts, :user_id
  end
end
