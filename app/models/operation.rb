class Operation < ApplicationRecord
  belongs_to :account

  validates_presence_of :operation, :value
  validates_presence_of :account_id_to_transfer, if: -> { transference? }
  validate :balance, if: -> { withdraw? or transference? }
  validate :dont_allow_update, on: :update #to not generate inconsistency in the account balances

  after_create :manage_value

  enum operation: [:deposit, :withdraw, :transference]

  def manage_value
    case operation
    when 'deposit'
      account.update(balance: account.balance + value)
    when 'withdraw'
      account.update(balance: account.balance - value)
    else
      account.update(balance: account.balance - value)
      
      account_to_transfer = Account.find(account_id_to_transfer)
      account_to_transfer.update(balance: account_to_transfer.balance + value)
    end
  end

  def balance
    if account.balance < value
      errors.add(:base, 'insufficient funds')
    end
  end

  def dont_allow_update
    errors.add(:base, 'You cannot update an operation')
  end
end
