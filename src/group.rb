class Group < Shape
  attr_accessor :children

  def initialize(opts = {})
    super(opts)
    @children = []
    opts[:children].reduce(self, &:<<) if opts[:children]
  end

  def <<(c)
    c.parent = self
    @children << c
    self
  end

  def local_intersect(r)
    return [] if children.empty?
    return [] if RayTracer::BOUNDING_BOX_TEST && !hit_bounds(r)

    @children.map { |s| s.intersect(r) }
             .flatten
             .sort_by(&:t)
  end

  def bounds
    return @__bounds if @__bounds
    return [Tuple.point(0, 0, 0), Tuple.point(0, 0, 0)] if @children.empty?

    minmax = @children.map { |s| [s, expand_bounds(*s.bounds)] }
                      .map { |s, pts| pts.map { |p| s.transform * p } }
                      .flatten
                      .map(&:data)
                      .transpose
                      .map(&:minmax)
    @__bounds = [
      Tuple.point(minmax[0][0], minmax[1][0], minmax[2][0]),
      Tuple.point(minmax[0][1], minmax[1][1], minmax[2][1])
    ]
  end

  def expand_bounds(t, b)
    [t,
     Tuple.point(b.x, t.y, t.z),
     Tuple.point(t.x, b.y, t.z),
     Tuple.point(t.x, t.y, b.z),
     Tuple.point(t.x, b.y, b.z),
     Tuple.point(b.x, t.y, b.z),
     Tuple.point(b.x, b.y, t.z),
     b]
  end
end
