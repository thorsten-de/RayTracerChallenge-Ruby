module Transformations
  module_function

  def translation(x, y, z)
    t = Matrix.identity_matrix(4)
    t[0, 3] = x
    t[1, 3] = y
    t[2, 3] = z

    t
  end

  def scaling(x, y, z)
    t = Matrix.identity_matrix(4)
    t[0, 0] = x
    t[1, 1] = y
    t[2, 2] = z

    t
  end

  ROT_FACTORS = {
    x: [[1, 1], [2, 2], [2, 1], [1, 2]],
    y: [[0, 0], [2, 2], [0, 2], [2, 0]],
    z: [[0, 0], [1, 1], [1, 0], [0, 1]]
  }.freeze

  def rotation(axis, r)
    t = Matrix.identity_matrix(4)
    cos = Math.cos(r)
    sin = Math.sin(r)

    [cos, cos, sin, -sin]
      .zip(ROT_FACTORS[axis])
      .each do |value, pos|
        t[*pos] = value
      end

    t
  end

  def shearing(sxy, sxz, syx, syz, szx, szy)
    t = Matrix.identity_matrix(4)
    t[0, 1] = sxy
    t[0, 2] = sxz
    t[1, 0] = syx
    t[1, 2] = syz
    t[2, 0] = szx
    t[2, 1] = szy

    t
  end

  def view_transform(from, to, up)
    forward = (to - from).normalize
    left = forward.cross(up.normalize)
    true_up = left.cross(forward)

    orientation = Matrix.new(4, 4, [
                               left.x, left.y, left.z, 0,
                               true_up.x, true_up.y, true_up.z, 0,
                               -forward.x, -forward.y, -forward.z, 0,
                               0, 0, 0, 1
                             ])

    orientation * translation(-from.x, -from.y, -from.z)
  end
end
