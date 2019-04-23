module TupleHelper
  include BaseHelper
  def tuple(x, y, z, w)
    Tuple.new([x, y, z, w])
  end

  def point(x, y, z)
    Tuple.point(x, y, z)
  end

  def vector(x, y, z)
    Tuple.vector(x, y, z)
  end
end

World TupleHelper

Then('a.x = {float}') do |float|
  expect(@a.x).to equal(float)
end

Then('a.y = {float}') do |float|
  expect(@a.y).to equal(float)
end

Then('a.z = {float}') do |float|
  expect(@a.z).to equal(float)
end

Then('a.w = {float}') do |float|
  expect(@a.w).to equal(float)
end

Then('a is a point') do
  expect(@a.point?).to be true
end

Then('a is not a vector') do
  expect(@a.vector?).to be false
end

Then('a is not a point') do
  expect(@a.point?).to be false
end

Then('a is a vector') do
  expect(@a.vector?).to be true
end

Given('p ← {point}') do |p|
  @p = p
end

Then('p = {tuple}') do |t|
  expect_tuple_equals(@p, t)
end

Given('v ← {vector}') do |v|
  @v = v
end

Then('v = {tuple}') do |t|
  expect_tuple_equals(@v, t)
end

Given('a ← tuple\({float}, {float}, {float}, {float})') do |x, y, z, w|
  @a = tuple(x, y, z, w)
end

Given('a{int} ← tuple\({int}, {int}, {int}, {int})') do |i, x, y, z, w|
  put(:a, i, tuple(x, y, z, w))
end

Then('a{int} + a{int} = tuple\({int}, {int}, {int}, {int})') do |i, j, x, y, z, w|
  result = get(:a, i) + get(:a, j)
  expect_tuple_equals(result, tuple(x, y, z, w))
end

Given('p{int} ← point\\({int}, {int}, {int})') do |i, x, y, z|
  put(:p, i, point(x, y, z))
end

Then('p{int} - p{int} = vector\\({int}, {int}, {int})') do |i, j, x, y, z|
  expect_tuple_equals(
    get(:p, i) - get(:p, j),
    vector(x, y, z)
  )
end

Then('-a = tuple\\({float}, {float}, {float}, {float})') do |x, y, z, w|
  expect_tuple_equals(
    -@a, tuple(x, y, z, w)
  )
end

Then('p - v = point\\({int}, {int}, {int})') do |x, y, z|
  expect_tuple_equals(
    @p - @v,
    point(x, y, z)
  )
end

Given('v{int} ← vector\\({int}, {int}, {int})') do |i, x, y, z|
  put(:v, i, vector(x, y, z))
end

Then('v{int} - v{int} = vector\\({int}, {int}, {int})') do |i, j, x, y, z|
  expect_tuple_equals(
    get(:v, i) - get(:v, j),
    vector(x, y, z)
  )
end

Then('a * {float} = tuple\\({float}, {float}, {float}, {float})') do |s, x, y, z, w|
  expect_tuple_equals(
    @a * s,
    tuple(x, y, z, w)
  )
end

Then("a \/ {float} = tuple\\({float}, {float}, {float}, {float})") do |s, x, y, z, w|
  expect_tuple_equals(
    @a / s,
    tuple(x, y, z, w)
  )
end

Then('magnitude\(v) = {float}') do |mag|
  expect(@v.magnitude).to eps(mag)
end

Then('magnitude\(v) = √{int}') do |mag|
  expect(@v.magnitude).to eps(Math.sqrt(mag))
end

Then('normalize\(v) = vector\({float}, {float}, {float})') do |x, y, z|
  expect_tuple_equals(@v.normalize, vector(x, y, z))
end

When('norm ← normalize\(v)') do
  @norm = @v.normalize
end

Then('magnitude\(norm) = {float}') do |expected|
  expect(@norm.magnitude).to be(expected)
end

Then('dot\(v{int}, v{int}) = {num}') do |i, j, expected|
  expect(get(:v, i).dot(get(:v, j))).to eps(expected)
end

Then('cross\(v{int}, v{int}) = vector\({int}, {int}, {int})') do |i, j, x, y, z|
  expect_tuple_equals(
    get(:v, i).cross(get(:v, j)),
    vector(x, y, z)
  )
end

## COLORS

Given('c ← color\({float}, {float}, {float})') do |r, g, b|
  @c = color(r, g, b)
end

Then('c.red = {float}') do |float|
  expect(@c.red).to eq(float)
end

Then('c.green = {float}') do |float|
  expect(@c.green).to eq(float)
end

Then('c.blue = {float}') do |float|
  expect(@c.blue).to eq(float)
end

Given('c{int} ← color\({float}, {float}, {float})') do |int, r, g, b|
  put(:c, int, color(r, g, b))
end

Then('c{int} + c{int} = c') do |i, j|
  expect_tuple_equals(
    get(:c, i) + get(:c, j),
    @c
  )
end

Then('c{int} - c{int} = c') do |i, j|
  expect_tuple_equals(
    get(:c, i) - get(:c, j),
    @c
  )
end

Then('c{int} * {int} = c') do |i, scalar|
  expect_tuple_equals(
    get(:c, i) * scalar,
    @c
  )
end

Then('c{int} * c{int} = c') do |i, j|
  expect_tuple_equals(
    get(:c, i).product(get(:c, j)),
    @c
  )
end
