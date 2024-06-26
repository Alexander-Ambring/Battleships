# File: battleships.rb
# Author: Alexander Ambring
# Date: 2024-06-03
# Description: This program is a strategic guessing game


#Initializing
require 'ruby2d'

Square_size = 60 #Size of each square in pixels
Grid_width = 20 #How many squares on the x-axis
Grid_height = 10 #How many squares on the y-axis
Grid_color = Color.new('#d3d3d3') #Color of the lines in the grid
set background: '#004080' #Background color

set width: Grid_width * Square_size #Set window width
set height: Grid_height * Square_size #Set window height

#Creates lines on the x-axis as new objects that acts like a grid
(0..Window.width).step(Square_size).each do |x|
  Line.new(x1: x, x2: x, y1: 0, y2: Window.height, width: 2, color: Grid_color, z: 1, opacity: 0.05)
end

#Creates lines on the y-axis as new objects that acts like a grid
(0..Window.height).step(Square_size).each do |y|
  Line.new(y1: y, y2: y, x1: 0, x2: Window.width, width: 2, color: Grid_color, z: 1, opacity: 0.05)
end

#Creates a line in the center to seperate each players side
Line.new(x1: 10*Square_size, x2: 10*Square_size, y1: 0, y2: Window.height, width: 2, color: 'black', z: 1)

#Creates a new class "Ship"
class Ship < Rectangle

  #Initializes the class, which is a rectangle with several properties.
  def initialize(x, y, width, height, color)
    super(x: x, y: y, width: width, height: height, color: color, z: 40)
    @frozen = false
    @rotation = false
  end

  #Checks if the ship has been placed
  def frozen?
    @frozen
  end

  #Freezes the ship location when placed
  def freeze
    @frozen = true
  end

  #Checks if the ship is inside player 1 boundary
  def inside_boundary_1?
    return x >= 0 && y >= 0 && x <= (Window.width)/2 - width && y <= Window.height - height
  end

  #Checks if the ship is inside player 2 boundary
  def inside_boundary_2?
    return x >= 10*Square_size && y >= 0 && x <= (Window.width) - width && y <= Window.height - height
  end

  #Checks if the ship has been rotated
  def rotation?
    @rotation
  end

  #Rotates the ship
  def rotate
    temp = self.width
    self.width = self.height
    self.height = temp
    @rotation = !@rotation
  end

  #Makes the ship invisible
  def hide
    self.color.opacity = 0
  end

  #Makes the ship visible
  def reveal
    self.color.opacity = 1
  end
end

#Checks if the coordinates is inside player 1 boundary. Not a built in function so it can be used for things other than the ships.
def inside_boundary_1(x, y)
  return x >= 0 && y >= 0 && x <= (Window.width)/2 && y <= Window.height
end

#Checks if the coordinates is inside player 2 boundary. Not a built in function so it can be used for things other than the ships.
def inside_boundary_2(x, y)
  return x >= 10*Square_size && y >= 0 && x <= (Window.width) && y <= Window.height
end

#Checks if the location would overlap with another ship
def overlap?(current_ship, ship_locations)
  for location in ship_locations
    if current_ship.x1 >= location[0] && current_ship.x1 < location[1]
      if current_ship.y1 <= location[2] && current_ship.y3 > location[2]
        return true
      end
    end
    if current_ship.x1 <= location[0] && current_ship.x2 > location[0]
      if current_ship.y1 >= location[2] && current_ship.y3 <= location[3]
        return true
      end
    end
  end
  return false
end

#Checks if you hit a ship when guessing
def hit?(ship_locations, current_x, current_y)
  for location in ship_locations
    if current_x > location[0] && current_x < location[1]
      if current_y > location[2] && current_y < location[3]
        return true
      end
    end
  end
  return false
end

#Creates ships for player 1
ships_1 = [
  Ship.new(0, 0, Square_size * 5, Square_size, '#E3242B'),    # Carrier
  Ship.new(0, 0, Square_size * 4, Square_size, '#E3242B'),    # Battleship
  Ship.new(0, 0, Square_size * 3, Square_size, '#E3242B'),    # Destroyer
  Ship.new(0, 0, Square_size * 3, Square_size, '#E3242B'),    # Submarine
  Ship.new(0, 0, Square_size * 2, Square_size, '#E3242B')     # Patrol Boat
]

#Creates ships for player 2
ships_2 = [
  Ship.new(0, 0, Square_size * 5, Square_size, '#E3242B'),    # Carrier
  Ship.new(0, 0, Square_size * 4, Square_size, '#E3242B'),    # Battleship
  Ship.new(0, 0, Square_size * 3, Square_size, '#E3242B'),    # Destroyer
  Ship.new(0, 0, Square_size * 3, Square_size, '#E3242B'),    # Submarine
  Ship.new(0, 0, Square_size * 2, Square_size, '#E3242B')     # Patrol Boat
]

#Hides the ships so they are not visible at the beginning of the game
for ship in ships_1
  ship.hide
end

for ship in ships_2
  ship.hide
end

#Initializing arrays and variables
ship_locations_1 = []
ship_locations_2 = []
current_ship_index_1 = 0
current_ship_index_2 = 0
player1_done = false
player2_done = false
hits_1 = 0
hits_2 = 0
turn_1 = true
current_ship = ships_1[0]

#The main loop that plays the entire game
update do

  #Gets the mouse position
  current_x = (get :mouse_x)
  current_y = (get :mouse_y)

  #Stage one of the game, when the players have not placed the ships yet
  if !player1_done || !player2_done

    #Reveals the current ship being placed
    if !player1_done
      current_ship = ships_1[current_ship_index_1]
      current_ship.reveal
    elsif !player2_done
      current_ship = ships_2[current_ship_index_2]
      current_ship.reveal
    end

    #Makes the current ship follow the mouse movements
    if !current_ship.frozen?
      current_ship.x = (current_x/Square_size)*Square_size
      current_ship.y = (current_y/Square_size)*Square_size
    end
  end

  #Hides the ships after placing them all
  if player1_done
    for ship in ships_1
      ship.hide
    end
  end
  if player2_done
    for ship in ships_2
      ship.hide
    end
  end
end

#Checks for mouseclicks to do certain actions
on :mouse do |event|
  if event.button == :left && event.type == :down

    #Placing stage of the game
    if !player1_done || !player2_done

      #Checks if the position is allowed, and if so places the ship
      if current_ship.inside_boundary_1? && !overlap?(current_ship, ship_locations_1) && !player1_done
        ship_locations_1 << [current_ship.x1, current_ship.x3, current_ship.y1, current_ship.y3]
        current_ship.freeze

        #Moves on to the next ship
        if current_ship_index_1 < ships_1.length
          current_ship_index_1 += 1
        end

        #If all ships are placed, moves on to player 2
        if current_ship_index_1 == 5 && !player1_done
          player1_done = true
        end

      #Checks if the position is allowed, and if so places the ship
      elsif current_ship.inside_boundary_2? && !overlap?(current_ship, ship_locations_2) && player1_done
        ship_locations_2 << [current_ship.x1, current_ship.x3, current_ship.y1, current_ship.y3]
        current_ship.freeze

        #Moves on to the next ship
        if current_ship_index_2 < ships_2.length
          current_ship_index_2 += 1
        end

        #If all ships are placed, moves on to guessing stage
        if current_ship_index_2 == 5 && !player2_done
          player2_done = true
        end
      end
    else
      #Gets mouse position
      current_x = (get :mouse_x)
      current_y = (get :mouse_y)

      #If player 1 turn and makes a eligible guess, makes the guess and moves on to player 2
      if turn_1 && inside_boundary_2(current_x, current_y)
        if hit?(ship_locations_2, current_x, current_y)
          Circle.new(x: (current_x/Square_size+0.5)*Square_size, y: (current_y/Square_size+0.5)*Square_size, radius: 30, color: 'red')
          hits_1 += 1
        else
          Circle.new(x: (current_x/Square_size+0.5)*Square_size, y: (current_y/Square_size+0.5)*Square_size, radius: 30, color: 'white')
        end
        turn_1 = !turn_1
        
      #If player 2 turn and makes a eligible guess, makes the guess and moves on to player 1
      elsif !turn_1 && inside_boundary_1(current_x, current_y)
        if hit?(ship_locations_1, current_x, current_y)
          Circle.new(x: (current_x/Square_size+0.5)*Square_size, y: (current_y/Square_size+0.5)*Square_size, radius: 30, color: 'red')
          hits_2 += 1
        else
          Circle.new(x: (current_x/Square_size+0.5)*Square_size, y: (current_y/Square_size+0.5)*Square_size, radius: 30, color: 'white')
        end
        turn_1 = !turn_1
      end


    end
  end
end

#Checks for "r" clicks to rotate the ship
on :key_down do |event|
  if event.key == "r" && !current_ship.frozen?
    current_ship.rotate
  end
end

#Shows the window
show
