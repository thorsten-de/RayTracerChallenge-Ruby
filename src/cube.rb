class Cube < Shape
  def local_intersect(ray)
    local_intersect_bounds(ray)
  end

  def local_normal_at(point)
    idx, value = (0..2).zip(point.data).max_by do |_, value|
      value.abs
    end

    v_data = [0, 0, 0, 0]
    v_data[idx] = value

    Tuple.new(v_data)
  end
end
