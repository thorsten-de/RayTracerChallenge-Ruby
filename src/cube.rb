class Cube < Shape
  def local_intersect(ray)
    group = ray.origin.zip(ray.direction)
               .take(3)
               .map { |p, v| check_axis(p, v) }
               .transpose
    tmin = group[0].max
    tmax = group[1].min

    return [] if tmin > tmax

    [Intersection.new(tmin, self), Intersection.new(tmax, self)]
  end

  def check_axis(origin, direction)
    tmin_numerator = (-1 - origin)
    tmax_numerator = (1 - origin)

    tmin, tmax = if direction.abs >= 0.0 # RayTracer::EPSILON
                   [tmin_numerator / direction,
                    tmax_numerator / direction]
                 else
                   [tmin_numerator * Float::INFINITY,
                    tmax_numerator * Float::INFINITY]
    end

    tmin > tmax ? [tmax, tmin] : [tmin, tmax]
  end

  def local_normal_at(point)
    idx, value = (0..2).zip(point.data).max_by do |_, value|
      value.abs
    end

    v_data = [0, 0, 0, 0]
    v_data[idx] = value

    Tuple.new(v_data)
  end
end
