class Cylinder < Shape
  attr_accessor :minimum, :maximum, :closed

  def initialize(opts = {})
    super(opts)
    @minimum = opts[:minimum] || -Float::INFINITY
    @maximum = opts[:maximum] || Float::INFINITY
    @closed = opts[:closed] || false
  end

  def bounds
    [Tuple.point(-1, @minimum, -1),
     Tuple.point(1, @maximum, 1)]
  end

  def local_intersect(ray)
    d = ray.direction
    o = ray.origin
    a, b, c = calculate_abc(o, d)

    finished, intersections = check_abc(a, b, c)
    return intersects_caps(ray, intersections) if finished

    disc = b * b - 4 * a * c

    return [] if disc < 0

    t0 = (-b - Math.sqrt(disc)) / (2 * a)
    t1 = (-b + Math.sqrt(disc)) / (2 * a)
    xs = if t0 > t1
           [t1, t0]
         else
           [t0, t1]
    end

    intersections = (xs.filter do |t|
      y = o.y + t * d.y
      @minimum < y && y < @maximum
    end).map { |t| Intersection.new(t, self) }

    intersects_caps(ray, intersections)
  end

  def calculate_abc(o, d)
    [
      d.x * d.x + d.z * d.z,
      2 * o.x * d.x + 2 * o.z * d.z,
      o.x * o.x + o.z * o.z - 1
    ]
  end

  def check_abc(a, _b, _c)
    [a.abs <= RayTracer::EPSILON, []]
  end

  def local_normal_at(p)
    dist = p.x * p.x + p.z * p.z
    if (dist < 1) && (p.y >= @maximum - RayTracer::EPSILON)
      Tuple.vector(0.0, 1.0, 0.0)
    elsif (dist < 1) && (p.y <= @minimum + RayTracer::EPSILON)
      Tuple.vector(0.0, -1.0, 0.0)
    else
      lateral_normal_at(p)
    end
  end

  def lateral_normal_at(p)
    Tuple.vector(p.x, 0.0, p.z)
  end

  def check_cap(ray, t, _y)
    x = ray.origin.x + t * ray.direction.x
    z = ray.origin.z + t * ray.direction.z

    (x * x + z * z) <= 1
  end

  def intersects_caps(ray, xs)
    return xs if !@closed || ray.direction.y.abs <= RayTracer::EPSILON

    [@minimum, @maximum]
      .map { |y| [y, (y - ray.origin.y) / ray.direction.y] }
      .filter { |y, t| check_cap(ray, t, y) }
      .each { |_y, t| xs << Intersection.new(t, self) }

    xs
  end
end

class Cone < Cylinder
  def bounds
    [
      Tuple.point(@minimum, @minimum, @minimum),
      Tuple.point(@maximum, @maximum, @maximum)
    ]
  end

  def calculate_abc(o, d)
    [
      d.x * d.x - d.y * d.y + d.z * d.z,
      2 * o.x * d.x - 2 * o.y * d.y + 2 * o.z * d.z,
      o.x * o.x - o.y * o.y + o.z * o.z
    ]
  end

  def check_abc(a, b, c)
    if a.abs <= RayTracer::EPSILON
      if b.abs <= RayTracer::EPSILON
        return [true, []]
      else
        return [true, [Intersection.new(-c / (2 * b), self)]]
      end
    end
    [false, []]
  end

  def lateral_normal_at(p)
    y = Math.sqrt(p.x * p.x + p.z * p.z)
    y = -y if p.y > 0

    Tuple.vector(p.x, y, p.z)
  end

  def check_cap(ray, t, y)
    x = ray.origin.x + t * ray.direction.x
    z = ray.origin.z + t * ray.direction.z

    (x * x + z * z) <= y.abs
  end
end
