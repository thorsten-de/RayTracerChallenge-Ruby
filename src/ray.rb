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

  def intersect(obj)
    sphere_to_ray = @origin - Tuple.point(0, 0, 0)

    a = @direction.dot(@direction)
    b = 2 * @direction.dot(sphere_to_ray)
    c = sphere_to_ray.dot(sphere_to_ray) - 1

    discriminant = b * b - 4 * a * c

    if discriminant < 0
      []
    else
      [ (-b - Math.sqrt(discriminant)) / (2 * a),
        (-b + Math.sqrt(discriminant)) / (2 * a)]
    end

  end
end

class Sphere
  def initialize
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
end