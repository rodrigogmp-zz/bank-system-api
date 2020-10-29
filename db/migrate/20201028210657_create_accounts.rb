class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.bigint :cpf, limit: 11
      t.float :balance, default: 0

      t.timestamps
    end
  end
end
