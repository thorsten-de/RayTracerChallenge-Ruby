class Sphere
  attr_accessor(:material)

  def initialize
    @transform = Matrix.identity
    @origin = Tuple.point(0.0, 0.0, 0.0)
    @material = Material.new()
  end

  def origin
    @origin
  end

  def transform
    @transform
  end

  def transform=(m)
    @transform = m
    @_inverse = nil 
  end

  def inverse_transform
    #@transform.inverse
    @_inverse ||= @transform.inverse
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
end