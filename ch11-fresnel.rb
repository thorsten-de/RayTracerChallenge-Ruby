require_relative './raytracer.rb'

white = Color::WHITE
black = Color::BLACK

floor_material = Material.new(
  color: Tuple.color(1, 1, 1),
  specular: 0,
  pattern: Pattern.checkers(Tuple.color(0.2, 1, 0), Tuple.color(1, 0.2, 0))
)
world = World.new(
  lights: [Light.point_light(Tuple.point(10, 10, 10), Tuple.color(1, 1, 1))],
  objects: [
    # wall as horizon
    Plane.new(
      material: Material.new(
        specular: 0,
        ambient: 1,
        diffuse: 0,
        pattern: Pattern.checkers(white, black)
      ),
      transform: Matrix.I.rotate(:x, Math::PI / 2).translate(0, 0, 12)
    ),
    # water
    Sphere.new(
      material: Material.new(
        color: Tuple.color(0.4, 0.5, 0.6),
        reflective: 0.8,
        transparency: 0.9,
        refractive_index: 1.52,
        diffuse: 0.4
      ),
      transform: Matrix.I.scale(1.2, 1.2, 1.2)
    ),

    Sphere.new(
      material: Material.new(
        color: Tuple.color(0.4, 0.5, 0.6),
        reflective: 0.8,
        transparency: 0.9,
        refractive_index: 1.003,
        diffuse: 0.0
      ),
      transform: Matrix.I.scale(0.6, 0.6, 0.6)
    )

  ]
)

camera = Camera.new(400, 400, Math::PI / 3)
camera.transform = Transformations.view_transform(Tuple.point(0, -1, -3),
                                                  Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
