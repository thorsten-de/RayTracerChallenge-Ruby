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

  def w=(value)
    @data[3] = value
  end

  def vector?
    w == 0.0
  end

  def point?
    w == 1.0
  end

  def [](idx)
    @data[idx]
  end

  def self.vector(x, y, z)
    Tuple.new([x, y, z, 0])
  end

  def self.point(x, y, z)
    Tuple.new([x, y, z, 1])
  end

  attr_reader :data

  def zip(other)
    @data.zip(other.data)
  end

  def ==(other)
    data == other.data if other.respond_to?(:data)
  end

  def +(other)
    zip_map(other, &:+)
  end

  def -(other)
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
    @data.zip(other.data).map { |a, b| a * b }.sum
  end

  def cross(other)
    Tuple.vector(
      y * other.z - z * other.y,
      z * other.x - x * other.z,
      x * other.y - y * other.x
    )
  end

  def magnitude
    Math.sqrt(
      @data.map { |vi| vi * vi }
      .sum
    )
  end

  def normalize
    map_scalar(magnitude, &:/)
  end

  def reflect(normal)
    self - (normal * 2 * dot(normal))
  end

  def zip_map(other)
    Tuple.new(
      @data.zip(other.data).map { |vi, wi| yield(vi, wi) }
    )
  end

  def map_scalar(scalar)
    Tuple.new(
      @data.map { |v| yield(v, scalar) }
    )
  end

  def map(&block)
    Tuple.new(
      @data.map(&block)
    )
  end

  # Implementation of Colors... Very lazy....
  def self.color(r, g, b)
    Tuple.new([r, g, b, 0])
  end

  def red
    @data[0]
  end

  def green
    @data[1]
  end

  def blue
    @data[2]
  end

  def product(other)
    zip_map(other, &:*)
  end

  def to_ppm_color(factor)
    @data[0..2].map do |c|
      [0, [factor, (c * factor).round].min].max.to_s
    end
  end

  def to_matrix
    Matrix.new(4, 1, @data)
  end

  def inspect
    ['(', @data.join(', '), ')'].join
  end
end

module Color
  BLACK = Tuple.color(0.0, 0.0, 0.0)
  WHITE = Tuple.color(1.0, 1.0, 1.0)
end
