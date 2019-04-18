require_relative './raytracer.rb'

class Ch06
  def initialize(opts = {})
    @opts = opts
    @opts = @opts.merge(
      pixel_size: opts[:wall_size] / opts[:canvas_pixels],
      half: opts[:wall_size] / 2
    )
  end

  def render(opts = {})
    canvas = Canvas.new(@opts[:canvas_pixels], @opts[:canvas_pixels])
    shape = opts[:shape] || Sphere.new
    color = opts[:color]
    shape.material.color = color if color

    light = opts[:light] || Light.point_light(Tuple.point(-10.0, 10, -10.0), Tuple.color(1.0, 1.0, 1.0))

    canvas.map! do |c, x, y|
      w_y = @opts[:half] - @opts[:pixel_size] * y
      w_x = - @opts[:half] + @opts[:pixel_size] * x

      p = Tuple.point(w_x, w_y, @opts[:wall_z])

      r = Ray.new(@opts[:ray_origin], (p - @opts[:ray_origin]).normalize)
      xs = shape.intersect(r)

      if (hit = Intersection.hit(xs))
        point = r.position(hit.t)
        normal = hit.object.normal_at(point)
        eye = -r.direction

        hit.object.material.lightning(light, point, eye, normal)
      else
        c
      end
    end

    canvas.save_ppm(opts[:filename])
  end
end

scene = Ch06.new ray_origin: Tuple.point(0.0, 0.0, -5.0),
                 wall_z: 10.0,
                 wall_size: 7.0,
                 canvas_pixels: 200

scene.render(filename: 'test.ppm', color: Tuple.color(1, 0.2, 1))
