class Triangle < Shape
  attr_accessor :p, :e, :normal

  def initialize(p, opts = {})
    super(opts)
    @p = p
    @e = [p[1] - p[0],
          p[2] - p[0]]
    @normal = e[1].cross(e[0]).normalize
  end

  def local_normal_at(_point, _hit = nil)
    @normal
  end

  def local_intersect(ray)
    dir_cross_e2 = ray.direction.cross(@e[1])
    det = @e[0].dot(dir_cross_e2)

    return [] if det.abs < RayTracer::EPSILON

    f = 1.0 / det
    p1_to_origin = ray.origin - @p[0]
    u = f * p1_to_origin.dot(dir_cross_e2)
    return [] if (u < 0) || (u > 1)

    origin_cross_e1 = p1_to_origin.cross(@e[0])
    v = f * ray.direction.dot(origin_cross_e1)
    return [] if (v < 0) || (u + v) > 1

    t = f * @e[1].dot(origin_cross_e1)
    [Intersection.new(t, self, u, v)]
  end
end

class SmoothTriangle < Triangle
  attr_reader :n

  def initialize(vertices, opts = {})
    super(vertices, opts)
    @n = opts[:normals] || []
  end

  def local_normal_at(_any_point, hit)
    @n[1] * hit.u + @n[2] * hit.v +
      @n[0] * (1 - hit.u - hit.v)
  end
end
