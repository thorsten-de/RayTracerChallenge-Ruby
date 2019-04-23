class Material
  attr_accessor(:color, :ambient, :diffuse, :specular, :shininess, :pattern)

  def initialize(opts = {})
    @color = opts[:color] || Tuple.color(1.0, 1.0, 1.0)
    @ambient = opts[:ambient] || 0.1
    @diffuse = opts[:diffuse] || 0.9
    @specular = opts[:specular] || 0.9
    @shininess = opts[:shininess] || 200.0
    @pattern = opts[:pattern]
  end

  def ==(other)
    @color == other.color &&
      @ambient == other.ambient &&
      @diffuse == other.diffuse &&
      @specular == other.specular &&
      @shininess == other.shininess
  end
end
