require_relative './raytracer.rb'
floor_material = Material.new(
  color: Tuple.color(1, 0.9, 0.9),
  specular: 0
)
world = World.new(
  lights: [Light.point_light(Tuple.point(-10, 10, -10), Tuple.color(1, 1, 1))],
  objects: [
    # Floor
    Sphere.new(
      transform: Transformations.scaling(10, 0.01, 10),
      material: floor_material
    ),
    # Left Wall
    Sphere.new(
      transformation: Transformations.translation(0, 0, 5) *
        Transformations.rotation(:y, Math::PI / 4) *
        Transformations.rotation(:x, Math::PI / 2) *
        Transformations.scaling(10, 0.01, 10),
      material: floor_material
    ),
    # Right Wall
    Sphere.new(
      transformation: Transformations.translation(0, 0, 5) *
        Transformations.rotation(:y, - Math::PI / 4) *
        Transformations.rotation(:x, Math::PI / 2) *
        Transformations.scaling(10, 0.01, 10),
      material: floor_material
    ),
    # Middle
    Sphere.new(
      transform: Transformations.translation(-0.5, 1, 0.5),
      material: Material.new(
        color: Tuple.color(0.1, 1.0, 0.5),
        diffuse: 0.7,
        specular: 0.3
      )
    ),
    # Right
    Sphere.new(
      transform: Transformations.translation(-0.5, 1, 0.5),
      material: Material.new(
        color: Tuple.color(0.1, 1.0, 0.5),
        diffuse: 0.7,
        specular: 0.3
      )
    ),
    # Left
    Sphere.new(
      transform: Transformations.translation(-0.5, 1, 0.5),
      material: Material.new(
        color: Tuple.color(0.1, 1.0, 0.5),
        diffuse: 0.7,
        specular: 0.3
      )
    )
  ]
)

camera = Camera.new(100, 50, Math::PI / 3)
camera.transform = Transformations.view_transform(Tuple.point(0, 1.5, -5),
                                                  Tuple.point(0, 1, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
