class MatchesController < ApplicationController

    def show
        match = Match.find(params[:id] )
        render json: match,
            include: [:foods] 
    end

    def update
        # This will set the x and y positions of the food items and position them
        # it will return 
            food=Food.find(params[:food_id])
            food.x_pos=params[:x_pos]
            food.y_pos=params[:y_pos]
            food.vertical=params[:vertical]
            food.save
            food.position
            food.reload
        render json: food.food_grids
#            include: [:food_grids]

    end

end