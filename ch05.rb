require_relative './raytracer.rb'

class Ch05
  def initialize(opts = {})
    @opts = opts
    @opts = @opts.merge(
      pixel_size: opts[:wall_size] / opts[:canvas_pixels],
      half: opts[:wall_size] / 2
    )
  end

  def render(opts = {})
    canvas = Canvas.new(@opts[:canvas_pixels], @opts[:canvas_pixels])
    color = opts[:color] || Tuple.color(1.0, 0.0, 0.0)
    shape = opts[:shape] || Sphere.new()

    canvas.map! do |c, x, y|
      w_y = @opts[:half] - @opts[:pixel_size] * y
      w_x = - @opts[:half] + @opts[:pixel_size] * x

      p = Tuple.point(w_x, w_y, @opts[:wall_z])

      r = Ray.new(@opts[:ray_origin], (p - @opts[:ray_origin]).normalize)
      xs = shape.intersect(r)

      if hit = Intersection.hit(xs)
        color
      else 
        c
      end
    end

    canvas.save_ppm(opts[:filename])
  end

end

scene = Ch05.new ray_origin: Tuple.point(0.0,0.0, -5.0),
  wall_z: 10.0,
  wall_size: 7.0,
  canvas_pixels: 100

p(scene)

scene.render(filename: "test.ppm")