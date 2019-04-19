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
