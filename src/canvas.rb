require 'pmap'

class Canvas

  def initialize(width, height)
    @width = width
    @height = height
    @data = Array.new(width * height, Tuple.color(0.0, 0.0, 0.0))
  end

  def width 
    @width
  end

  def height
    @height
  end

  def [](x, y)
    @data[x + @width * y]
  end

  def []=(x, y, value)
    if x >= 0 && x < @width && y >= 0 && y < @height
      @data[x + @width * y] = value
    end
  end

  def each_pixel
    (0..@data.length - 1).each do |i|
      yield(i % @width, i / @width)
    end
  end

  def map!
    @data.map!.with_index do |item, i|
      yield(item, i % @width, i / @width)
    end
  end

  def all_pixel
    @data
  end

  def all_pixel=(value)
    @data.map!{|_| value}
  end

  def to_ppm
    factor = 255
    s = "P3\n#{@width} #{height}\n#{factor}\n"
    
    ((0..@height-1).map do |j|
      (0..@width-1).map {|i| self[i, j].to_ppm_color(factor)}
        .join(" ")
    end).reduce(s) {|acc, r| split_row_before_70(acc, r)}
  end

  SPLIT_AT = 70
  def split_row_before_70(s, r)
    return ((s << r) << "\n") if r.length <= SPLIT_AT
      
    idx = r.rindex(" ", SPLIT_AT - 1)
    (s << r[0..idx-1]) << "\n"
    return split_row_before_70(s, r[(idx + 1) .. -1])
  end    

  def save_ppm(filename)
    open(filename, 'w') do |f|
      f.puts(to_ppm)
    end
  end

  def to_s
    "<Canvas #{@width}x#{@height}>"
  end

  def inspect
    to_s
  end
end