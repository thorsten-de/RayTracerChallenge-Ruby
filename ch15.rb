require_relative './raytracer.rb'

WHITE = Color::WHITE
BLACK = Color::BLACK
GRAY = Tuple.color(0.5, 0.5, 0.5)

teapot = ObjFile.from_file('files/teapot.obj')

world = World.new(
  lights: [
    Light.point_light(Tuple.point(-5, 10, -5), Tuple.color(1, 1, 1))
  ],
  objects: [
    teapot
  ]
)

camera = Camera.new(80, 60, Math::PI / 2)
camera.transform = Transformations.view_transform(Tuple.point(1, 1, -2),
                                      1           Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
