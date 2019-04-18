require 'ostruct'

class Ray
  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end

  attr_reader :origin

  attr_reader :direction

  def position(t)
    @origin + @direction * t
  end

  def transform(m)
    Ray.new(m * @origin,
            m * @direction)
  end

  def intersect(obj)
    sphere_to_ray = @origin - Tuple.point(0, 0, 0)

    a = @direction.dot(@direction)
    b = 2 * @direction.dot(sphere_to_ray)
    c = sphere_to_ray.dot(sphere_to_ray) - 1

    discriminant = b * b - 4 * a * c

    if discriminant < 0
      []
    else
      Intersection.intersections(
        Intersection.new((-b - Math.sqrt(discriminant)) / (2 * a), obj),
        Intersection.new((-b + Math.sqrt(discriminant)) / (2 * a), obj)
      )
    end
  end

  def prepare_computations(xs)
    point = position(xs.t)
    eyev = -@direction
    normalv = xs.object.normal_at(point)

    inside, normalv = if normalv.dot(eyev) < 0
                        [true, -normalv]
                      else
                        [false, normalv]
    end
    OpenStruct.new(t: xs.t,
                   object: xs.object,
                   point: point,
                   over_point: point + normalv * RayTracer::EPSILON,
                   eyev: eyev,
                   normalv: normalv,
                   inside: inside)
  end
end

class Intersection
  def initialize(t, o)
    @object = o
    @t = t
  end

  attr_reader :object

  attr_reader :t

  def self.intersections(*args)
    args
  end

  def self.hit(xs)
    xs.reject { |x| x.t < 0 }
      .min_by(&:t)
  end
end
