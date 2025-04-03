class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :register, :login ]
  require "jwt"
  SECRET_KEY = Rails.application.secret_key_base
  def register
    @user=User.new(user_params)
    if @user.save
      WelcomeEmailJob.perform_later(@user)
      @user=User.find_by(email: params[:email])
      token= generate_token(@user.id)
      cookies.signed[:jwt] = { value: token, httponly: true, expires: 2.days.from_now }
      redirect_to "/get-tasks", notice: "User created successfully" and return
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def login
    puts
    user=User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token= generate_token(user.id)
      cookies.signed[:jwt] = { value: token, httponly: true, expires: 2.days.from_now }
      redirect_to "/get-tasks", notice: "User login successfully" and return
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
