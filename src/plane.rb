# Eine Ebene, planar auf der XZ-Achse durch den Ursprung
class Plane < Shape
  def local_normal_at(_every_point)
    Tuple.vector(0, 1, 0)
  end

  def bounds
    [
      Tuple.point(-Float::INFINITY, 0, -Float::INFINITY),
      Tuple.point(Float::INFINITY, 0, Float::INFINITY)
    ]
  end

  def local_intersect(ray)
    return [] if ray.direction.y.abs < RayTracer::EPSILON

    [Intersection.new(-ray.origin.y / ray.direction.y, self)]
  end
end
