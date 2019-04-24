require_relative './raytracer.rb'

white = Color::WHITE
black = Color::BLACK

floor_material = Material.new(
  color: Tuple.color(1, 1, 1),
  reflective: 0.3,
  pattern: Pattern.checkers(white, black, transform: Transformations.scaling(0.1, 0.1, 0.1))
)

wall_material = Material.new(
  color: Tuple.color(0.8, 0.8, 0.5),
  specular: 0.05
)

world = World.new(
  lights: [Light.point_light(Tuple.point(1, 1, 1), Tuple.color(1, 1, 1))],
  objects: [
    # Walls
    Cube.new(
      transform: Matrix.I.scale(10, 10, 10),
      material: wall_material
    ),

    Cube.new(
      transform: Matrix.I.scale(10, 4, 10),
      material: floor_material
    )
  ]
)

camera = Camera.new(400, 300, Math::PI / 2)
camera.transform = Transformations.view_transform(Tuple.point(0, 0, -5),
                                                  Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
