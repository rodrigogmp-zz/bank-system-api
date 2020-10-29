class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_v1_user!, except: :create

  def create
    @user = User.create(sign_up_params)

    if @user.errors.any?
      return render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end

    render json: @user
  end

  private

  def sign_up_params
    params.require(:email)
    params.require(:password)
    params.permit(:email, :password)
  end
end
