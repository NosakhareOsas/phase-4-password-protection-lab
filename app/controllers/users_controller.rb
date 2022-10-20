class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_error
    def create
        user = User.create!(post_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show

        user = User.find_by(id: session[:user_id])
        if user 
            render json: user
        else
            render json: { error: "Not authorized" }, status: :unauthorized
        end  
    end

    private
    def post_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_unprocessable_entity_error(invalid)
        render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
