require 'ruby2d'

# Set window size
set width: 400, height: 400

# Draw a rectangle with opacity
Rectangle.new(
  x: 100, y: 100,
  width: 200, height: 200,
  color: [0, 0, 255, 0.05],
  z: 1, # Specify z-order
)

show
