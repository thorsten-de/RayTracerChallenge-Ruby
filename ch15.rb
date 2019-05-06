require_relative './raytracer.rb'

WHITE = Color::WHITE
BLACK = Color::BLACK
GRAY = Tuple.color(0.5, 0.5, 0.5)

teapot = ObjFile.from_file('files/teapot-low.obj')
teapot.transform = teapot.transform.rotate(:x, -Math::PI / 2)

world = World.new(
  lights: [
    Light.point_light(Tuple.point(100, 100, 200), Tuple.color(1, 1, 1))
  ],
  objects: [
    teapot
  ]
)

camera = Camera.new(800, 600, Math::PI / 2)
camera.transform = Transformations.view_transform(Tuple.point(10, 20, 20),
                                                  Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
