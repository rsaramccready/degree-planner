class Api::V1::ApiController < ApplicationController
  skip_before_action :require_authenticated_user
  before_action :authenticate_request
  skip_before_action :verify_authenticity_token

  attr_reader :current_user

  private

  def authenticate_request
    token = extract_token
    if token
      begin
        @current_user = decode_token(token)
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: 'Invalid or expired token' }, status: :unauthorized
      end
    else
      render json: { error: 'Missing token' }, status: :unauthorized
    end
  end

  def extract_token
    auth_header = request.headers['Authorization']
    auth_header.split(' ').last if auth_header && auth_header.start_with?('Bearer ')
  end

  def decode_token(token)
    decoded = JWT.decode(token, jwt_secret, true, { algorithm: 'HS256' })
    user_id = decoded[0]['user_id']
    User.find(user_id)
  end

  def encode_token(user_id, exp = 24.hours.from_now)
    payload = {
      user_id: user_id,
      exp: exp.to_i
    }
    JWT.encode(payload, jwt_secret, 'HS256')
  end

  def jwt_secret
    Rails.application.credentials.secret_key_base
  end
end
