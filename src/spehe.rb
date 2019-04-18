class Sphere
  attr_accessor(:material, :origin)

  def initialize(opts = {})
    @transform = opts[:transform] || Matrix.identity
    @origin = Tuple.point(0.0, 0.0, 0.0)
    @material = opts[:material] || Material.new
  end

  attr_reader :transform

  def transform=(m)
    @transform = m
    @_inverse = nil
  end

  def inverse_transform
    @inverse_transform ||= @transform.inverse
  end

  def intersect(original_ray)
    original_ray
      .transform(inverse_transform)
      .intersect(self)
  end

  def normal_at(world_p)
    object_p = inverse_transform * world_p
    object_normal = object_p - origin

    world_normal = inverse_transform.transpose * object_normal
    world_normal.w = 0
    world_normal.normalize
  end

  def ==(other)
    @origin == other.origin &&
      @material == other.material &&
      @transform == other.transform
  end
end
