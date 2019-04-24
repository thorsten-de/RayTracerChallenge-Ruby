class Cylinder < Shape
  attr_accessor :minimum, :maximum

  def initialize
    @minimum = -Float::INFINITY
    @maximum = Float::INFINITY
  end

  def local_intersect(ray)
    r = ray.direction
    a = r.x * r.x + r.z * r.z
    return [] unless a.abs >= RayTracer::EPSILON

    p = ray.origin
    b = 2 * p.x * r.x + 2 * p.z * r.z
    c = p.x * p.x + p.z * p.z - 1

    disc = b * b - 4 * a * c

    return [] if disc < 0

    t0 = (-b - Math.sqrt(disc)) / (2 * a)
    t1 = (-b + Math.sqrt(disc)) / (2 * a)
    xs = if t0 > t1
           [t1, t0]
         else
           [t0, t1]
    end

    (xs.filter do |t|
      y = p.y + t * r.y
      @minimum < y && y < @maximum
    end).map { |t| Intersection.new(t, self) }
  end

  def local_normal_at(point)
    Tuple.vector(point.x, 0.0, point.z)
  end
end
