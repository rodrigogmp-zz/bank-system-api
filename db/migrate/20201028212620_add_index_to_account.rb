class AddIndexToAccount < ActiveRecord::Migration[5.2]
  def change
    add_index :accounts, :cpf
  end
end
