class Api::V1::OperationsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_account

  def index
    @operations = @account.operations

    render json: @operations
  end

  def create
    @operation = @account.operations.create(operation_params)

    if @operation.errors.any?
      return render json: { errors: @operation.errors.full_messages }, status: :unprocessable_entity
    end

    render json: @operation
  end

  private

  def set_account
    @account = current_api_v1_user.account

    if @account.nil?
      return render json: { message: "Account not found" }, status: :not_found
    end
  end

  def operation_params
    params.require(:operation)
    params.require(:value)
    params.permit(:operation, :value, :account_id_to_transfer)
  end
end
