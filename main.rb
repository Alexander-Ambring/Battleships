require 'ruby2d'

Grid_size = 60
Squares_width = 10
Squares_height = 10
Grid_color = Color.new('#d3d3d3')
set background: '#004080'

set width: Squares_width * Grid_size
set height: Squares_height * Grid_size

(0..Window.width).step(Grid_size).each do |x|
  Line.new(x1: x, x2: x, y1: 0, y2: Window.height, width: 2, color: Grid_color, z: 1, opacity: 0.05)
end

(0..Window.height).step(Grid_size).each do |y|
  Line.new(y1: y, y2: y, x1: 0, x2: Window.width, width: 2, color: Grid_color, z: 1, opacity: 0.05)
end

ship_locations = []
frozen = []

Carrier = Rectangle.new(
  x: 0, y: 0,
  width: Grid_size*5, height: Grid_size,
  color: '#E3242B'
)

Battleship = Rectangle.new(
  x: 0, y: 0,
  width: Grid_size*4, height: Grid_size,
  color: '#E3242B'
)

Destroyer = Rectangle.new(
  x: 0, y: 0,
  width: Grid_size*3, height: Grid_size,
  color: '#E3242B'
)

Submarine = Rectangle.new(
  x: 0, y: 0,
  width: Grid_size*3, height: Grid_size,
  color: '#E3242B'
)

Patrol_Boat = Rectangle.new(
  x: 0, y: 0,
  width: Grid_size*2, height: Grid_size,
  color: '#E3242B'
)

ship = [Carrier, Battleship, Destroyer, Submarine, Patrol_Boat]
current_ship = ship[0]
i = 0

update do
  current_x = (get :mouse_x)
  current_y = (get :mouse_y)
  current_ship = ship[i]
  if frozen[i] != true
    current_ship.x = (current_x/60)*60
    current_ship.y = (current_y/60)*60
  elsif i <= 3
    i += 1
  end
  p ship_locations
end

on :mouse do |event|
  if event.button == :left && event.type == :down
    ship_locations << [(current_ship.x/60).to_int, (current_ship.y/60).to_int]
    frozen << true
  end
end

on :key_down do |event|
  if event.key == "r" && frozen[i] != true && current_ship.width > current_ship.height
    temp = current_ship.width
    current_ship.width = current_ship.height
    current_ship.height = temp
  elsif event.key == "r" && frozen[i] != true && current_ship.height > current_ship.width
    temp = current_ship.width
    current_ship.width = current_ship.height
    current_ship.height = temp
  end
end

show
