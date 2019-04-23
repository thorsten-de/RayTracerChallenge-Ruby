class World
  attr_accessor :lights, :objects

  def initialize(opts = {})
    @objects = opts[:objects] || []
    @lights = opts[:lights] || []
    @universe_background = Color::BLACK
  end

  def self.default
    w = World.new
    w.lights = [Light.point_light(Tuple.point(-10.0, 10.0, -10.0),
                                  Tuple.color(1.0, 1.0, 1.0))]

    s1 = Sphere.new
    s1.material.color = Tuple.color(0.8, 1.0, 0.6)
    s1.material.diffuse = 0.7
    s1.material.specular = 0.2

    s2 = Sphere.new
    s2.transform = s2.transform.scale(0.5, 0.5, 0.5)

    w.objects = [s1, s2]
    w
  end

  def light
    @lights[0]
  end

  def contains?(obj)
    @objects.include? obj
  end

  def intersect(ray)
    @objects.flat_map { |o| o.intersect(ray) }
            .sort_by(&:t)
  end

  def shade_hit(comps, remaining = 5)
    surface = lights.reduce(Color::BLACK) do |color, light|
      color + PhongShader.lightning(comps.object.material,
                                    comps.object,
                                    light,
                                    comps.over_point,
                                    comps.eyev,
                                    comps.normalv,
                                    is_shadowed(comps.over_point, light))
    end
    reflected = reflected_color(comps, remaining)
    surface + reflected
  end

  def color_at(ray, remaining = 5)
    intersections = intersect(ray)
    if (hit = Intersection.hit(intersections))
      comps = ray.prepare_computations(hit)
      shade_hit(comps, remaining)
    else
      @universe_background
    end
  end

  def is_shadowed(point, source = light)
    point_to_light = source.position - point
    distance = point_to_light.magnitude

    ray = Ray.new(point, point_to_light.normalize)

    xs = intersect(ray)
    if (hit = Intersection.hit(xs))
      hit.t < distance
    else
      false
    end
  end

  def reflected_color(comps, remaining = 5)
    reflective = comps.object.material.reflective

    return Color::BLACK if remaining == 0 || reflective == 0.0

    ray = Ray.new(comps.over_point, comps.reflectv)
    color_at(ray, remaining - 1) * reflective
  end
end
