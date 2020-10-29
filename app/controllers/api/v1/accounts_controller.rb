class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_api_v1_user!
  before_action :set_account, except: [:create, :index]

  def create
    @account = Account.create(account_create_params.merge(user_id: current_api_v1_user.id))

    if @account.errors.any?
      return render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end

    render json: @account
  end

  def update
    unless @account.update(account_update_params)
      return render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end

    render json: @account
  end

  def destroy
    unless @account.destroy
      render json: { errors: @account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @account
  end

  def bank_statement
    render json: BankStatementBuilder.new(@account).perform
  end

  private

  def set_account
    @account = current_api_v1_user.account

    if @account.nil?
      return render json: { message: "You don't have an account yet" }, status: :not_found
    end
  end

  def account_create_params
    params.require(:cpf)
    params.permit(:cpf, :balance)
  end

  def account_update_params
    params.require(:cpf)
    params.permit(:cpf)
  end
end
