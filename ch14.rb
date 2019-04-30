require_relative './raytracer.rb'

white = Color::WHITE
black = Color::BLACK

def hexagon_corner
  Sphere.new(
    transformation: Matrix.I.scale(0.25, 0.25, 0.25).translate(0, 0, -1)
  )
end

g = Group.new
g << hexagon_corner

world = World.new(
  lights: [
    Light.point_light(Tuple.point(-10, 20, -20), Tuple.color(1, 1, 1))
  ],
  objects: [
    g
  ]
)

camera = Camera.new(240, 135, Math::PI / 2)
camera.transform = Transformations.view_transform(Tuple.point(0, 0, -5),
                                                  Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
