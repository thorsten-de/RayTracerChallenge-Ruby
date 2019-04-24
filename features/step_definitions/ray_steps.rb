module RayHelper
  include BaseHelper

  def r
    @_r ||= {}
  end

  def i
    @_i ||= {}
  end

  def ray(origin, direction)
    Ray.new(origin, direction)
  end

  def sphere
    Sphere.new
  end

  def hit(xs)
    Intersection.hit(xs)
  end
end

World RayHelper

When('r ← ray\\(p, v)') do
  @r = ray(@p, @v)
end

Then('r.origin = origin') do
  expect_tuple_equals(@r.origin, @p)
end

Then('r.direction = direction') do
  expect_tuple_equals(@r.direction, @v)
end

Given('r ← ray\({point}, {vector})') do |origin, direction|
  @r = ray(origin, direction)
end

Then('position\(r, {num}) = point\({num}, {num}, {num})') do |t, x, y, z|
  expect_tuple_equals(
    @r.position(t),
    point(x, y, z)
  )
end

Given('s ← sphere') do
  @s = sphere
end

When('xs ← intersect\\(s, r)') do
  @xs = @s.intersect(@r)
end

Then('xs.count = {num}') do |num|
  expect(@xs.length).to eq(num)
end

Then('xs[{int}].t = {num}') do |i, num|
  expect(@xs[i].t).to eps(num)
end

When('i ← intersection\\({num}, s)') do |t|
  @i = Intersection.new(t, @s)
end

Then('i.t = {num}') do |num|
  expect(@i.t).to eq(num)
end

Then('i.object = s') do
  expect(@i.object).to eq(@s)
end

Given('i{int} ← intersection\\({num}, s)') do |i0, t|
  i[i0] = Intersection.new(t, @s)
end

When('xs ← intersections\\(i{int}, i{int})') do |i1, i2|
  @xs = Intersection.intersections(i[i1], i[i2])
end

Then('xs[{int}].object = s') do |i|
  expect(@xs[i].object).to be(@s)
end

When('i ← hit\\(xs)') do
  @i = hit(@xs)
end

Then('i = i{int}') do |int|
  expect(@i).to be(i[int])
end

Then('i is nothing') do
  expect(@i).to be(nil)
end

Given('xs ← intersections\(i1, i2, i3, i4)') do
  @xs = Intersection.intersections(
    i[1], i[2], i[3], i[4]
  )
end

Given('m ← translation\\({num}, {num}, {num})') do |x, y, z|
  @m = translation(x, y, z)
end

Given('m ← scaling\\({num}, {num}, {num})') do |x, y, z|
  @m = scaling(x, y, z)
end

When('r{int} ← transform\\(r, m)') do |i|
  r[i] = @r.transform(@m)
end

Then('r{int}.origin = {point}') do |i, p|
  expect_tuple_equals(
    r[i].origin,
    p
  )
end

Then('r{int}.direction = {vector}') do |i, v|
  expect_tuple_equals(
    r[i].direction,
    v
  )
end

Then('s.transform = identity_matrix') do
  matrix_equals(
    @s.transform,
    identity_matrix
  )
end

When('set_transform\\(s, m)') do
  @s.transform = @m
end

Then('s.transform = m') do
  matrix_equals(
    @s.transform,
    @m
  )
end
