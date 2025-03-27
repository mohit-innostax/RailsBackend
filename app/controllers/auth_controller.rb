class AuthController < ApplicationController
  require "jwt"
  SECRET_KEY = Rails.application.secret_key_base
  def register
    user=User.new(user_params)
    if user.save
      render json: { user: user, message: "User registered" }, status: 201
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def login
    user=User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token= generate_token(user.id)
      render json: { token: token, user: user }, status: :ok
    else
      render json: { error: "Invalid creds" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
  def generate_token(id)
    JWT.encode({ id: id }, SECRET_KEY, "HS256")
  end
end
