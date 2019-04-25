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
  end

  def intersect(ray)
    local_ray = ray.transform(inverse_transform)
    local_intersect(local_ray)
  end

  def local_intersect(_ray)
    throw NotImplementedError
  end

  def normal_at(point)
    object_point = world_to_object(point)
    object_normal = local_normal_at(object_point)
    normal_to_world(object_normal)
  end

  def local_normal_at(_point)
    throw NotImplementedError
  end

  def world_to_object(point)
    point = @parent.world_to_object(point) if @parent

    inverse_transform * point
  end

  def normal_to_world(vector)
    v = inverse_transform.transpose * vector
    v.w = 0
    v = v.normalize
    if @parent
      @parent.normal_to_world(v)
    else
      v
    end
  end
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
