class UsersController < ApplicationController
    def create
        user = User.new(user_params)
    
        if user.save
          session[:user_id] = user.id
          render json: user, only: [:id, :username, :image_url, :bio], status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
    def show
      if logged_in?
        user = current_user
        render json: user, only: [:id, :username, :image_url, :bio], status: :ok
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  
    private
  
    def logged_in?
      session[:user_id].present? && User.exists?(session[:user_id])
    end
  
    def current_user
      User.find_by(id: session[:user_id])
    end
  
    def user_params
        params.require(:user).permit(:username, :password, :password_confirmation, :image_url, :bio)
      end
  end