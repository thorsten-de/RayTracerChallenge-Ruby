class Triangle < Shape
  attr_accessor :p, :e, :normal

  def initialize(p, opts = {})
    super(opts)
    @p = p
    @e = [p[1] - p[0],
          p[2] - p[0]]
    @normal = e[1].cross(e[0]).normalize
  end
end
