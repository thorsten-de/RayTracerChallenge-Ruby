require_relative './raytracer.rb'

red = Tuple.color(0.8, 0.2, 0.2)
white = Color::WHITE

floor_material = Material.new(
  color: Tuple.color(1, 0.9, 0.9),
  specular: 0,
  pattern: Pattern.checkers(white, Color::BLACK)
)
world = World.new(
  lights: [Light.point_light(Tuple.point(10, 4, -10), Tuple.color(1, 1, 1))],
  objects: [
    # Floor
    Plane.new(
      transform: Transformations.translation(0, 0, 0),
      material: floor_material
    ),
    Plane.new(
      material: floor_material,
      transform: Matrix.I
        .rotate(:x, -Math::PI / 2)
        .translate(0, 0, 12)
    ),
    Plane.new(
      material: floor_material,
      transform: Matrix.I
        .rotate(:z, -Math::PI / 2)
        .translate(-6, 0, 0)
    ),
    Plane.new(
      material: floor_material,
      transform: Matrix.I.translate(0, 4.2, 0)
    ),
    # Middle
    Sphere.new(
      transform: Transformations.translation(-0.5, 1, 0.5),
      material: Material.new(
        color: Tuple.color(0.1, 1.0, 0.5),
        diffuse: 0.7,
        specular: 0.3,
        pattern: Pattern.checkers(white, red,
                                  transform: ::Matrix.I
                                  .scale(0.2, 0.3, 0.4)
                                  .rotate(:z, Math::PI / 4))
      )
    ),
    # Right
    Sphere.new(
      transform: Transformations.translation(1.5, 0.5, -0.5) *
      Transformations.scaling(0.5, 0.5, 0.5),
      material: Material.new(
        color: Tuple.color(0.5, 1.0, 0.1),
        diffuse: 0.7,
        specular: 0.3,
        pattern: Pattern.ring(white, red,
                              transform: Transformations.scaling(0.2, 0.3, 0.4))
      )
    ),
    # Left
    Sphere.new(
      transform: Transformations.translation(-1.5, 0.33, -0.75) *
      Transformations.scaling(0.33, 0.33, 0.33),
      material: Material.new(
        color: Tuple.color(1, 0.8, 0.1),
        diffuse: 0.7,
        specular: 0.3,
        refraction_factor: 1.52,
        transparency: 1.0
      )
    )
  ]
)

camera = Camera.new(392, 208, Math::PI / 3)
camera.transform = Transformations.view_transform(Tuple.point(0, 1.5, -5),
                                                  Tuple.point(0, 1, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
