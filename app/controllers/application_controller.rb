class ApplicationController < ActionController::Base
  # Used if we are sending JWT token from the Frontend
  # before_action :authorize_request, except: [ :register, :login ]
  # SECRET_KEY=Rails.application.secret_key_base
  # def authorize_request
  #   token=request.headers["Authorization"]
  #   if token.present?
  #     decode_the_token=JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
  #     @current_user= User.find(decode_the_token["id"])
  #   else
  #     render json: { error: "Unauthorized" }, status: :unauthorized
  #   end
  # rescue JWT::DecodeError
  #   render json: { error: "Invalid Token" }, status: :unauthorized
  # end

  # Used if we are extracting JWT token from the cookies for authentication
  include ActionController::Cookies
  protect_from_forgery with: :null_session
  before_action :authorize_request, except: [ :register, :login ]
  SECRET_KEY= Rails.application.secret_key_base
  include ActionController::Cookies
  private
  def authorize_request
    token= cookies.signed[:jwt]
    if token.blank?
      render json: { error: "Please login" }, allow_other_host: true, alert: "Session expired. Please log in again." and return
    end
    begin
      decode_the_token= JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
      @user= User.find(decode_the_token["id"])
    rescue JWT:: ExpiredSignature
      refresh_token
    rescue JWT::DecodeError
      cookies.delete(:jwt)
      redirect_to "http://localhost:3000/register", allow_other_host: true and return
    end
  end
  def refresh_token
    if @user
      new_token = generate_jwt(@user.id)
      cookies.signed[:jwt] = { value: new_token, httponly: true, expires: 2.days.from_now }
    else
      cookies.delete(:jwt)
      redirect_to "http://localhost:3000/register", allow_other_host: true and return
    end
  end
  def generate_jwt(id)
    payload = { id: id, exp: 2.days.from_now.to_i }
    JWT.encode(payload, SECRET_KEY, "HS256")
  end
end
