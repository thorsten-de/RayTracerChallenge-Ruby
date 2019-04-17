class Material
  attr_accessor(:color, :ambient, :diffuse, :specular, :shininess)

  def initialize(opts = {})
    @color = opts[:color] || Tuple.color(1.0, 1.0, 1.0)
    @ambient = opts[:ambient] || 0.1
    @diffuse = opts[:diffuse] || 0.9
    @specular = opts[:specular] || 0.9
    @shininess = opts[:shininess] || 200.0
  end

  def ==(other)
    @color == other.color &&
    @ambient == other.ambient &&
    @diffuse == other.diffuse &&
    @specular == other.specular &&
    @shininess == other.shininess
  end

  def lightning(light, point, eyev, normalv)
    effective_color = @color.product(light.intensity)

    lightv = (light.position - point).normalize

    ambient = effective_color * @ambient
    diffuse = Color::BLACK
    specular = Color::BLACK

    light_dot_normal = lightv.dot(normalv)
    unless light_dot_normal < 0 
      diffuse = effective_color * @diffuse * light_dot_normal

      reflectv = (-lightv).reflect(normalv)
      reflect_dot_eye = reflectv.dot(eyev)
      if reflect_dot_eye > 0
        factor = reflect_dot_eye ** @shininess
        specular = light.intensity * @specular * factor
      end
    end

    ambient + diffuse + specular
  end
end