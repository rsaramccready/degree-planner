class Api::V1::UsersController < Api::V1::ApiController
  skip_before_action :authenticate_request, only: [:create]

  def show
    user = User.find(params[:id])
    render json: {
      id: user.id,
      email: user.email,
      name: user.name,
      created_at: user.created_at
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def create
    user = User.new(user_params)

    if user.save
      token = encode_token(user.id)
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name
        }
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])

    unless current_user.id == user.id
      return render json: { error: 'Unauthorized' }, status: :forbidden
    end

    if user.update(user_update_params)
      render json: {
        id: user.id,
        email: user.email,
        name: user.name
      }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :email)
  end
end
