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
end