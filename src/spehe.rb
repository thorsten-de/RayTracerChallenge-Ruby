class Shape
  attr_accessor :material
  attr_reader :transform

  def initialize(opts = {})
    @transform = opts[:transform] || Matrix.identity
    @material = opts[:material] || Material.new
    @origin = Tuple.point(0.0, 0.0, 0.0)
  end

  def transform=(matrix)
    @transform = matrix
    @inverse_transform = nil
  end

  def inverse_transform
    @inverse_transform ||= @transform.inverse
  end

  def intersect(ray)
    local_ray = ray.transform(inverse_transform)
    local_intersect(local_ray)
  end

  def local_intersect(ray); end

  def normal_at(point)
    object_point = inverse_transform * point

    object_normal = local_normal_at(object_point)
    world_normal = inverse_transform.transpose * object_normal
    world_normal.w = 0
    world_normal.normalize
  end

  def local_normal_at(point); end
end

class TestShape < Shape
  attr_reader :saved_ray
  def local_intersect(ray)
    @saved_ray = ray
  end

  def local_normal_at(p)
    Tuple.vector(p.x, p.y, p.z)
  end
end

class Sphere < Shape
  def initialize(opts = {})
    super(opts)
  end

  def local_intersect(ray)
    ray.intersect(self)
  end

  def local_normal_at(object_p)
    object_p - @origin
  end

  def ==(other)
    @material == other.material &&
      @transform == other.transform
  end
end
