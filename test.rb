require 'ruby2d'

GRID_SIZE = 60
SQUARES_WIDTH = 10
SQUARES_HEIGHT = 10
GRID_COLOR = Color.new('#d3d3d3')

set background: '#004080'
set width: SQUARES_WIDTH * GRID_SIZE
set height: SQUARES_HEIGHT * GRID_SIZE

# Define a Ship class
class Ship < Rectangle
  def initialize(x, y, width, height, color)
    super(x: x, y: y, width: width, height: height, color: color)
    @frozen = false
    @rotation = false
    @ship_size = (width/GRID_SIZE).to_i
  end

  def frozen?
    @frozen
  end

  def rotation?
    @rotation
  end

  def ship_size?
    @ship_size
  end

  def freeze
    @frozen = true
  end

  def rotate
    temp = self.width
    self.width = self.height
    self.height = temp
    @rotation = !@rotation
  end
end

ships = [
  Ship.new(0, 0, GRID_SIZE * 5, GRID_SIZE, '#E3242B'),    # Carrier
  Ship.new(0, 0, GRID_SIZE * 4, GRID_SIZE, '#E3242B'),    # Battleship
  Ship.new(0, 0, GRID_SIZE * 3, GRID_SIZE, '#E3242B'),    # Destroyer
  Ship.new(0, 0, GRID_SIZE * 3, GRID_SIZE, '#E3242B'),    # Submarine
  Ship.new(0, 0, GRID_SIZE * 2, GRID_SIZE, '#E3242B')     # Patrol Boat
]

current_ship_index = 0

update do
  current_ship = ships[current_ship_index]
  if !current_ship.frozen?
    current_ship.x = ((get :mouse_x) / GRID_SIZE).to_i * GRID_SIZE
    current_ship.y = ((get :mouse_y) / GRID_SIZE).to_i * GRID_SIZE
  end
end

on :mouse do |event|
  current_ship = ships[current_ship_index]
  if event.button == :left && event.type == :down && !current_ship.frozen?
    if !current_ship.rotation? && (current_ship.x/GRID_SIZE).to_i-1 < 10-current_ship.ship_size?
      current_ship.freeze
      current_ship_index += 1 if current_ship_index < ships.length - 1
    elsif current_ship.rotation? && (current_ship.y/GRID_SIZE).to_i-1 < 10-current_ship.ship_size?
      current_ship.freeze
      current_ship_index += 1 if current_ship_index < ships.length - 1
    end
  end
end

on :key_down do |event|
  current_ship = ships[current_ship_index]
  if event.key == 'r' && !current_ship.frozen?
    current_ship.rotate
  end
end

# Draw grid lines
(SQUARES_WIDTH + 1).times do |x|
  Line.new(x1: x * GRID_SIZE, x2: x * GRID_SIZE, y1: 0, y2: SQUARES_HEIGHT * GRID_SIZE, width: 2, color: GRID_COLOR, z: 1, opacity: 0.05)
end

(SQUARES_HEIGHT + 1).times do |y|
  Line.new(y1: y * GRID_SIZE, y2: y * GRID_SIZE, x1: 0, x2: SQUARES_WIDTH * GRID_SIZE, width: 2, color: GRID_COLOR, z: 1, opacity: 0.05)
end

show
