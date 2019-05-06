class Shape
  attr_accessor :material, :parent
  attr_reader :transform

  def initialize(opts = {})
    @transform = opts[:transform] || Matrix.identity
    @material = opts[:material] || Material.new
    @parent = opts[:parent] || nil
    @origin = Tuple.point(0.0, 0.0, 0.0)
  end

  def transform=(matrix)
    @transform = matrix
    @inverse_transform = nil
  end

  def inverse_transform
    @inverse_transform ||= @transform.inverse
    # @transform.inverse
  end

  def intersect(ray)
    local_ray = ray.transform(inverse_transform)
    local_intersect(local_ray)
  end

  def local_intersect(_ray)
    throw NotImplementedError
  end

  def bounds
    [
      Tuple.point(-1, -1, -1),
      Tuple.point(1, 1, 1)
    ]
  end

  def local_intersect_bounds(ray)
    top, bottom = bounds
    group = ray.origin.zip(ray.direction)
               .take(3)
               .map.with_index { |args, i| check_axis(args[0], args[1], top[i], bottom[i]) }
               .transpose

    tmin = group[0].max
    tmax = group[1].min

    return [] if tmin > tmax

    [Intersection.new(tmin, self), Intersection.new(tmax, self)]
  end

  def hit_bounds(ray)
    !local_intersect_bounds(ray).empty?
  end

  def check_axis(origin, direction, min, max)
    tmin_numerator = (min - origin)
    tmax_numerator = (max - origin)

    tmin, tmax = if direction.abs >= RayTracer::EPSILON
                   [tmin_numerator / direction,
                    tmax_numerator / direction]
                 else
                   [tmin_numerator * Float::INFINITY,
                    tmax_numerator * Float::INFINITY]
    end

    tmin > tmax ? [tmax, tmin] : [tmin, tmax]
  end

  def normal_at(point, hit = nil)
    object_point = world_to_object(point)
    object_normal = local_normal_at(object_point, hit)
    normal_to_world(object_normal)
  end

  def local_normal_at(_point, _hit = nil)
    throw NotImplementedError
  end

  def world_to_object(point)
    point = @parent.world_to_object(point) if @parent

    inverse_transform * point
  end

  def normal_to_world(vector)
    v = (inverse_transform.transpose * vector)
    v.w = 0
    v = v.normalize
    v = @parent.normal_to_world(v) if @parent
    v
  end
end

class ErrorShape < Shape
end

class TestShape < Shape
  attr_reader :saved_ray
  def local_intersect(ray)
    @saved_ray = ray
  end

  def local_normal_at(p, _hit = nil)
    Tuple.vector(p.x, p.y, p.z)
  end
end
