require_relative './raytracer.rb'

white = Color::WHITE
black = Color::BLACK

floor_material = Material.new(
  color: Tuple.color(1, 1, 1),
  reflective: 0.3,
  pattern: Pattern.ring(white, black, transform: Transformations.scaling(0.1, 0.1, 0.1))
)

wall_material = Material.new(
  color: Tuple.color(0.8, 0.8, 0.5),
  specular: 0.05
)

world = World.new(
  lights: [
    Light.point_light(Tuple.point(8, 3, -1), Tuple.color(0.7, 0.75, 0.8)),
    Light.point_light(Tuple.point(-2, 3, -4), Tuple.color(0.8, 0.75, 0.7))
  ],
  objects: [
    # Walls
    Cube.new(
      transform: Matrix.I.scale(10, 10, 10),
      material: wall_material
    ),

    Cube.new(
      transform: Matrix.I.scale(10, 4, 10),
      material: floor_material
    ),
    Cylinder.new(
      minimum: -10.0,
      maximum: -2.0,
      closed: true,
      reflective: 0.7,
      material: Material.new(
        pattern: Pattern.checkers(white, Tuple.color(1, 0, 0), transform: Matrix.I.scale(0.2, 0.2, 0.2))
      )
    ),

    Cone.new(
      minimum: 0.0,
      maximum: 2.0,
      closed: true,
      reflective: 0.7,
      transform: Matrix.I.translate(0, 1, 0),
      material: Material.new(
        pattern: Pattern.ring(white, Tuple.color(0, 1, 0), transform: Matrix.I.scale(0.2, 0.2, 0.2))
      )
    )
  ]
)

camera = Camera.new(320, 240, Math::PI / 2)
camera.transform = Transformations.view_transform(Tuple.point(0, 0, -9),
                                                  Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
