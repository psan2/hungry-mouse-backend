class Game < ApplicationRecord
    has_many :players
    has_many :grids
end
