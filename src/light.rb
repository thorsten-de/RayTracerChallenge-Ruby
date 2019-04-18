class Light
  attr_reader(:position, :intensity)

  def initialize(position, intensity)
    @position = position
    @intensity = intensity
  end

  def self.point_light(position, intensity)
    Light.new(position, intensity)
  end

  def ==(other)
    @position == other.position &&
      @intensity == other.intensity
  end
end
