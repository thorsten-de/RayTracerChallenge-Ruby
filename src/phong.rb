module PhongShader
  def self.lightning(material, object, light, point, eyev, normalv, in_shadow = false)
    color = material.pattern ? material.pattern.pattern_at_shape(object, point) : material.color
    effective_color = color.product(light.intensity)

    lightv = (light.position - point).normalize

    ambient = effective_color * material.ambient
    diffuse = Color::BLACK
    specular = Color::BLACK

    light_dot_normal = lightv.dot(normalv)
    unless light_dot_normal < 0
      diffuse = effective_color * material.diffuse * light_dot_normal

      reflectv = (-lightv).reflect(normalv)
      reflect_dot_eye = reflectv.dot(eyev)
      if reflect_dot_eye > 0
        factor = reflect_dot_eye**material.shininess
        specular = light.intensity * material.specular * factor
      end
    end

    in_shadow ? ambient : ambient + diffuse + specular
  end
end
