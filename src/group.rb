class Group < Shape
  attr_accessor :children

  def initialize(opts = {})
    super(opts)
    @children = opts[:children] || []
  end

  def <<(c)
    c.parent = self
    @children << c
    self
  end

  def local_intersect(r)
    @children.map { |s| s.intersect(r) }
             .flatten
             .sort_by(&:t)
  end
end
