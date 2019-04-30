require_relative './raytracer.rb'

WHITE = Color::WHITE
BLACK = Color::BLACK

def hexagon_corner
  Sphere.new(
    transform: Matrix.I.scale(0.25, 0.25, 0.25).translate(0, 0, -1)
  )
end

def hexagon_edge
  Cylinder.new(
    minimum: 0,
    maximum: 1,
    transform: Matrix.I.scale(0.25, 1, 0.25)
       .rotate(:z, -Math::PI / 2)
       .rotate(:y, -Math::PI / 6)
       .translate(0, 0, -1)
  )
end

def hexagon_side(opts = {})
  Group.new(opts.merge(
              children: [
                hexagon_corner,
                hexagon_edge
              ]
            ))
end

def hexagon
  children = (0..5).map do |i|
    hexagon_side(transform: Matrix.I.rotate(:y, i * -Math::PI / 3))
  end
  Group.new children: children
end

world = World.new(
  lights: [
    Light.point_light(Tuple.point(-45, 100, -25), Tuple.color(1, 1, 1))
  ],
  objects: [
    hexagon
  ]
)

camera = Camera.new(240, 135, Math::PI / 2)
camera.transform = Transformations.view_transform(Tuple.point(0, 1, -2),
                                                  Tuple.point(0, 0, 0),
                                                  Tuple.vector(0, 1, 0))

canvas = camera.render(world)
canvas.save_ppm('test.ppm')
