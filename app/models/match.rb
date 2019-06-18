class Match < ApplicationRecord
    belongs_to :player
    belongs_to :game
    has_many :foods
    has_many :bites

    def other_matches( this_match=self )
        this_match.game.matches.select {|match|match.id!=this_match.id}.each {|current_match| }
    end

    def other_ai( this_match=self, current_round )
        other_matches(this_match).select {|match| match.player.ai==true && match.round_no<current_round}
    end

    def winner?( this_match=self )
        if other_matches(this_match).select{ |match| match.loser==false }.length==0
            this_match.winner=true;
            this_match.save;
        end
        this_match.winner
    end

    def bite(x_pos=0, y_pos=0 )
        # Nibble for self, then see if there is any AI to be done
        nibble_hash = {
            this_shot:{},
            ai_shots:[]
        }

        nibble_hash[:this_shot] = nibble(self, x_pos, y_pos)
# After having a nibble, check if the next player in the sequence is a computer,
# if so, run their game, not passing in positions, so they are computer generated
# GET ALL WITH ROUND_NO LESS THAN CURRENT ONE AND NIBBLE AWAY IF THEY ARE COMPUTERS
        other_ai( self, self.round_no ).each {|match|
            nibble_hash[:ai_shots] << nibble(match)
        } 

# Return the hash of the shot, and all others generated by a computer
        nibble_hash
    end

    def nibble(this_match, x_pos=0, y_pos=0)
# Run this for a player to take a nibble
# When a nibble is taken it can nibble or miss, 
# if nibble, it can eat the food fully or not
# if eaten the food, it could win the game
# After having a nibble, check if the next player in the sequence is a computer,
# if so, run their game, not passing in positions, so they are computer generated

# TODO Generate x and y if 0 for the AI ..... need to turn into a function and be smart
        if x_pos==0
            x_pos = rand(1..this_match.game.qty_columns)
        end
        if y_pos==0
            y_pos = rand(1..this_match.game.qty_rows)
        end 

        nibble_hash = { player:this_match.player.name,
                    round_no:this_match.round_no,
                    x_pos:x_pos,
                    y_pos:y_pos,
                    nibbled:false,
                    eaten:false,
                    won:false
                     } # Will be used to show what has happened

# Create the bite record
    thisbite = Bite.create(match_id:this_match.id, x_pos:x_pos, y_pos:y_pos)

    other_matches(this_match).each { |other_match|   
        other_match.foods.each { |other_food|
            FoodGrid.where(["food_id=? and x_pos=? and y_pos=?", other_food.id,x_pos, y_pos]).each {|other_foodgrid|
                other_foodgrid.bite=true
                nibble_hash[:nibbled]=true
                other_foodgrid.save
        # If no other bits to bite, then set the food item to eaten
            food_to_eat=FoodGrid.where(["food_id=? and bite = false ", other_foodgrid.food_id])
            if food_to_eat.length==0 
               other_foodgrid.food.eaten=true
               nibble_hash[:eaten]=true
               other_foodgrid.food.save

             # So if the food is eaten, see if there are any other uneaten foods for any other players in the game
                 if other_match.foods.select {|f| f.eaten==false }.length==0
                     # This match is a loser ..... we can't say we are a winner just yet, as there may be more than 2 players
                     other_match.loser=true;
                     other_match.save
                     # As we have set a player to being a loser, now is a good time to see if we are a winner
                     nibble_hash[:won]=winner?( this_match )
                 end # End the setting this player a loser stuff
 
            end # End the setting the food element to eaten
            } # End the other food_grid loop
          } # End the other_food loop
        } # End the other_match loop    

        # Set the round number
        this_match.round_no+=1
        this_match.save

        # Return the hash
        nibble_hash
    end

end
