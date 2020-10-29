class BankStatementBuilder
  def initialize(account)
    @account = account
  end

  def perform
    build_history

    @bank_statement = @bank_statement.sort_by { |data| data[:created_at] }.reverse!
  end

  private

  def build_history
    @bank_statement = []

    @account.operations.each do |op|
      operation_kind = op.operation

      case operation_kind
      when 'deposit'
        object = {
          balance_change: "+#{op.value}"
        }
      when 'withdraw'
        object = {
          balance_change: "-#{op.value}"
        }
      else
        object = {
          balance_change: "-#{op.value}",
          cpf_of_destiny: op.account.cpf
        }
      end

      @bank_statement << object.merge(action: op.operation == 'transference' ? 'transfer_performed': op.operation, created_at: op.created_at)
    end

    Operation.where(account_id_to_transfer: @account.id).each do |received_transfer|
      @bank_statement << {
        balance_change: "+#{received_transfer.value}",
        sender_cpf: received_transfer.account.cpf,
        action: 'transfer_received',
        created_at: received_transfer.created_at
      }
    end
  end
end