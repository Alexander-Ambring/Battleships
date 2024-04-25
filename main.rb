require 'ruby2d'

Square_size = 60
Grid_width = 10
Grid_height = 10
Grid_color = Color.new('#d3d3d3')
set background: '#004080'

set width: Grid_width * Square_size
set height: Grid_height * Square_size

(0..Window.width).step(Square_size).each do |x|
  Line.new(x1: x, x2: x, y1: 0, y2: Window.height, width: 2, color: Grid_color, z: 1, opacity: 0.05)
end

(0..Window.height).step(Square_size).each do |y|
  Line.new(y1: y, y2: y, x1: 0, x2: Window.width, width: 2, color: Grid_color, z: 1, opacity: 0.05)
end

class Ship < Rectangle
  def initialize(x, y, width, height, color)
    super(x: x, y: y, width: width, height: height, color: color)
    @frozen = false
    @rotation = false
  end

  def frozen?
    @frozen
  end

  def freeze
    @frozen = true
  end

  def inside_boundary?
    return x >= 0 && y >= 0 && x <= Window.width - width && y <= Window.height - height
  end

  def rotation?
    @rotation
  end

  def rotate
    temp = self.width
    self.width = self.height
    self.height = temp
    @rotation = !@rotation
  end

  def hide
    self.color.opacity = 0
  end

  def reveal
    self.color.opacity = 1
  end
end

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

ships = [
  Ship.new(0, 0, Square_size * 5, Square_size, '#E3242B'),    # Carrier
  Ship.new(0, 0, Square_size * 4, Square_size, '#E3242B'),    # Battleship
  Ship.new(0, 0, Square_size * 3, Square_size, '#E3242B'),    # Destroyer
  Ship.new(0, 0, Square_size * 3, Square_size, '#E3242B'),    # Submarine
  Ship.new(0, 0, Square_size * 2, Square_size, '#E3242B')     # Patrol Boat
]

for ship in ships
  ship.hide
end

ship_locations = []
current_ship = ships[0]
current_ship_index = 0
player1_done = false

update do
  current_x = (get :mouse_x)
  current_y = (get :mouse_y)
  current_ship = ships[current_ship_index]
  current_ship.reveal
  if !current_ship.frozen?
    current_ship.x = (current_x/Square_size)*Square_size
    current_ship.y = (current_y/Square_size)*Square_size
  end
  if player1_done
    for ship in ships
      ship.hide
    end
  end
end

on :mouse do |event|
  if event.button == :left && event.type == :down
    if current_ship_index == 4
      player1_done = true
    elsif current_ship.inside_boundary? && !overlap?(current_ship, ship_locations)
      ship_locations << [current_ship.x1, current_ship.x3, current_ship.y1, current_ship.y3]
      current_ship.freeze
      if current_ship_index < ships.length-1
        current_ship_index += 1
      end
    end
  end
end

on :key_down do |event|
  if event.key == "r" && !current_ship.frozen?
    current_ship.rotate
  end
end

show
