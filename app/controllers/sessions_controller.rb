class SessionsController < ApplicationController
    def create
      user = User.find_by(username: params[:username])
  
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        render json: user, only: [:id, :username, :image_url, :bio], status: :ok
      else
        render json: { error: "Invalid username or password" }, status: :unauthorized
      end
    end
  
    def destroy
      if logged_in?
        session.delete(:user_id)
        head :no_content
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  
    private
  
    def logged_in?
      session[:user_id].present? && User.exists?(session[:user_id])
    end
  end