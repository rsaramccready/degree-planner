class Api::V1::AuthController < Api::V1::ApiController
  skip_before_action :authenticate_request, only: [:login]

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name
        }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def refresh
    token = encode_token(current_user.id)
    render json: {
      token: token,
      user: {
        id: current_user.id,
        email: current_user.email,
        name: current_user.name
      }
    }, status: :ok
  end
end
