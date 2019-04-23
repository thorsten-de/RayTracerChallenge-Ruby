class Pattern
  attr_reader :transform

  def initialize(opts = {})
    @f = opts[:f]
    @transform = opts[:transform] || Matrix.I
  end

  def transform=(matrix)
    @transform = matrix
    @inverse_transform = nil
  end

  def inverse_transform
    @inverse_transform ||= @transform.inverse
  end

  def pattern_at(point)
    @f.call(point)
  end

  def pattern_at_shape(object, world_point)
    object_point = object.inverse_transform * world_point
    pattern_point = inverse_transform * object_point

    pattern_at(pattern_point)
  end

  def self.test_pattern
    Pattern.new(f: ->(p) { Tuple.color(p.x, p.y, p.z) })
  end

  def self.stripes(a, b, opts = {})
    Pattern.new(opts.merge(a: a, b: b, f: lambda { |point|
      point.x.floor.even? ? a : b
    }))
  end

  def self.gradient(a, b, opts = {})
    distance = b - a
    Pattern.new(opts.merge(
                  f: lambda { |p|
                    fraction = p.x - p.x.floor
                    a + distance * fraction
                  }
                ))
  end

  def self.ring(a, b, opts = {})
    Pattern.new(opts.merge(
                  f: lambda { |p|
                    if Math.sqrt(p.x * p.x + p.z * p.z).floor.even?
                      a
                    else
                      b
                    end
                  }
                ))
  end

  def self.checkers(a, b, opts = {})
    Pattern.new(opts.merge(
                  f: lambda { |p|
                    if (p.x.floor + p.y.floor + p.z.floor).even?
                      a
                    else
                      b
                    end
                  }
                ))
  end
end
