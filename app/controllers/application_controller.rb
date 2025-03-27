class ApplicationController < ActionController::API
  before_action :authorize_request, except: [ :register, :login ]
  SECRET_KEY=Rails.application.secret_key_base
  def authorize_request
    token=request.headers["Authorization"]
    if token.present?
      decode_the_token=JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")[0]
      @current_user= User.find(decode_the_token["id"])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: "Invalid Token" }, status: :unauthorized
  end
end
