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
    refracted = refracted_color(comps, remaining)
    material = comps.object.material

    if material.reflective > 0 && material.transparency > 0
      reflectance = World.schlick(comps)
      surface + reflected * reflectance + refracted * (1 - reflectance)
    else
      surface + reflected + refracted
    end
  end

  def color_at(ray, remaining = 5)
    intersections = intersect(ray)
    if (hit = Intersection.hit(intersections))
      comps = ray.prepare_computations(hit, intersections)
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

  def refracted_color(comps, remaining = 5)
    n_ratio = comps.n1 / comps.n2
    cos_i = comps.eyev.dot(comps.normalv)
    sin2_t = (n_ratio * n_ratio) * (1.0 - (cos_i * cos_i))

    return Color::BLACK if remaining == 0 ||
                           comps.object.material.transparency == 0.0 ||
                           sin2_t > 1

    cos_t = Math.sqrt(1.0 - sin2_t)

    direction = comps.normalv * (n_ratio * cos_i - cos_t) -
                comps.eyev * n_ratio

    ray = Ray.new(comps.under_point, direction)
    color_at(ray, remaining - 1) * comps.object.material.transparency
  end

  def self.schlick(comps)
    cos = comps.eyev.dot(comps.normalv)

    if comps.n1 > comps.n2
      n = comps.n1 / comps.n2
      sin2_t = n * n * (1.0 - cos * cos)
      return 1.0 if sin2_t > 1.0

      cos_t = Math.sqrt(1.0 - sin2_t)
      cos = cos_t
    end

    r0 = ((comps.n1 - comps.n2) / (comps.n1 + comps.n2))
    r0 *= r0

    x = (1 - cos)
    r0 + (1 - r0) * x * x * x * x * x
  end
end
