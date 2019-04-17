class Ray
  def initialize(origin, direction)
    @origin = origin
    @direction = direction
  end

  def origin
    @origin
  end

  def direction
    @direction
  end

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
end

class Sphere
  def initialize
    @transform = Matrix.identity
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
end

class Intersection
  def initialize(t, o)
    @object = o
    @t = t
  end

  def object
    @object
  end

  def t
    @t 
  end

  def self.intersections(*args)
    args
  end

  def self.hit(xs)
    xs.reject {|x| x.t < 0}
      .min {|xs1, xs2| xs1.t <=> xs2.t }
  end
end