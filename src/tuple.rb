class Tuple
  def initialize(data)
    @data = data
  end

  def x
    @data[0]
  end

  def y
    @data[1]
  end

  def z
    @data[2]
  end

  def w
    @data[3]
  end

  def vector?
    w == 0.0
  end

  def point?
    w == 1.0
  end

  def self.vector(x, y, z)
    Tuple.new([x, y, z, 0])
  end
  
  def self.point(x, y, z)
    Tuple.new([x, y, z, 1])
  end

  def data
    @data
  end

  def zip(other)
    @data.zip(other.data)
  end

  def ==( other )
    if other.respond_to?(:data)
      self.data == other.data
    end
  end

  def +( other )
    zip_map(other, &:+)
  end

  def -( other )
    zip_map(other, &:-)
  end

  def -@
    map(&:-@)
  end

  def *(scalar)
    map_scalar(scalar, &:*)
  end
  
  def /(scalar)
    map_scalar(scalar, &:/)
  end

  def dot(other)
    @data.zip(other.data).map {|a, b| a * b}.sum() 
  end

  def cross(other)
    Tuple.vector(
      self.y * other.z - self.z * other.y,
      self.z * other.x - self.x * other.z,
      self.x * other.y - self.y * other.x
    )
  end

  def magnitude
    Math::sqrt(
      @data.map {|vi| vi * vi }
      .sum
    )
  end

  def normalize
    map_scalar(magnitude, &:/)
  end

  def zip_map(other, &block)
    Tuple.new(
      @data.zip(other.data).map {|vi, wi| block.(vi, wi)}
    )
  end

  def map_scalar(scalar, &block)
    Tuple.new(
      @data.map {|v| block.(v, scalar) }
    )
  end

  def map(&block)
    Tuple.new(
      @data.map(&block)
    )
  end
end