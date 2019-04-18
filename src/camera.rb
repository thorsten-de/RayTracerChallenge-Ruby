class Camera
  attr_accessor :hsize, :vsize, :field_of_view, :transform

  attr_reader :transform, :pixel_size

  def initialize(h, v, fov)
    @hsize = h
    @vsize = v
    @field_of_view = fov

    @transform = Matrix.identity
    calculate_pixel_size
  end

  def calculate_pixel_size
    half_view = Math.tan(@field_of_view / 2)
    aspect = @hsize.to_f / @vsize.to_f

    @half_width, @half_height = if aspect >= 1
                                  [half_view, half_view / aspect]
                                else
                                  [half_view * aspect, half_view]
                                end

    @pixel_size = (2 * @half_width) / @hsize
  end

  def inverse_transform
    (@inverse_transform ||= @transform.inverse)
  end

  def ray_for_pixel(x, y)
    origin = inverse_transform * Tuple.point(0.0, 0.0, 0.0)
    p = inverse_transform * Tuple.point(
      @half_width - @pixel_size * (x + 0.5),
      @half_height - @pixel_size * (y + 0.5),
      -1
    )
    Ray.new(origin, (p - origin).normalize)
  end

  def render(world)
    canvas = Canvas.new(@hsize, @vsize)

    canvas.map! do |_c, x, y|
      ray = ray_for_pixel(x, y)
      world.color_at(ray)
    end
  end
end
