require_relative './raytracer.rb'

white = Color::WHITE
black = Color::BLACK

floor_material = Material.new(
  color: Tuple.color(1, 1, 1),
  specular: 0,
  pattern: Pattern.checkers(white, Color::BLACK)
)
world = World.new(
  lights: [Light.point_light(Tuple.point(10, 10, 10), Tuple.color(1, 1, 1))],
  objects: [
    # Floor
    Plane.new(
      material: floor_material,
      transform: Transformations.translation(0, -8, 0)
    ),
    # Middle
    Sphere.new(
      material: Material.new(
        color: Tuple.color(0.5, 0.5, 0.5),
        refractive_index: 1.5,
        transparency: 0.9
      )
    ),
    Sphere.new(
      material: Material.new(
        color: Tuple.color(0.5, 0.5, 0.5),
        transform: Transformations.scaling(0.9, 0.9, 0.9),
        diffuse: 0.0,
        ambient: 0.0,
        specular: 0.0,
        refractive_index: 1,
        transparency: 0.9
      )
    ),

    Sphere.new(
      material: Material.new(
        color: Tuple.color(0.5, 0.5, 0.5),
        transform: Transformations.scaling(0.5, 0.5, 0.5),
        diffuse: 0.0,
        refractive_index: 1.5,
        transparency: 0.9
      )
    )
  ]
)

camera = Camera.new(400, 400, Math::PI / 3)
camera.transform = Transformations.view_transform(Tuple.point(2, 2, 0),
                                                  Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
