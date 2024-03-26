require 'ruby2d'

Grid_size = 60
Squares_width = 20
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

Destroyer = Rectangle.new(
  x: 0, y: 0,
  width: Grid_size*3, height: Grid_size,
  color: '#E3242B'
)

update do
  current_x = (get :mouse_x) - 30
  current_y = (get :mouse_y) - 30
  if frozen[0] != true
    Destroyer.x = current_x
    Destroyer.y = current_y
  end
end

on :mouse do |event|
  if event.button == :left && event.type == :down
    ship_locations << [Destroyer.x/60, Destroyer.y/60]
    frozen << true
  end
end

show
