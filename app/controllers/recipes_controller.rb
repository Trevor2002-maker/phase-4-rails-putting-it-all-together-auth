class RecipesController < ApplicationController
    def index
      if logged_in?
        recipes = Recipe.all.includes(:user)
        render json: recipes, include: { user: { only: [:id, :username, :image_url, :bio] } }, only: [:id, :title, :instructions, :minutes_to_complete], status: :ok
      else
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  
    def create
        if logged_in?
          recipe = current_user.recipes.build(recipe_params)
    
          if recipe.save
            render json: recipe_with_user(recipe), status: :created
          else
            render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end
  
      private

      def logged_in?
        session[:user_id].present?
      end
    
      def current_user
        User.find(session[:user_id])
      end
    
      def recipe_params
        params.require(:recipe).permit(:title, :instructions, :minutes_to_complete)
      end
    
      def recipe_with_user(recipe)
        recipe.as_json(include: { user: { only: [:id, :username, :image_url, :bio] } })
      end
  end