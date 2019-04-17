module TransformationsHelper
  include BaseHelper

  def translation(x, y, z)
    Transformations.translation(x, y, z)
  end

  def scaling(x, y, z)
    Transformations.scaling(x, y, z)
  end
  
  def rotation(axis, r)
    Transformations.rotation(axis.to_sym, r)
  end

  def shearing(sxy, sxz, syx, syz, szx, szy)
    Transformations.shearing(sxy, sxz, syx, syz, szx, szy)
  end

  def m
    (@_m ||= {})
  end
  
  POINT_MAP = {
    "0" => 0,
    "√2/2" => Math.sqrt(2) / 2, 
    "-√2/2" => -Math.sqrt(2) / 2
  }
  
  def point_from_strings(x, y, z)
    point(POINT_MAP[x], POINT_MAP[y], POINT_MAP[z])
  end
end

World TransformationsHelper

Given("transform ← translation\\({int}, {int}, {int})") do |x, y, z|
  @transform = translation(x, y, z)
end

Then("transform * p = point\\({int}, {int}, {int})") do |x, y, z|
expect_tuple_equals(
  @transform * @p,
  point(x, y, z)
)
end

Given("inv ← inverse\\(transform)") do
  @inv = @transform.inverse
end

Then("inv * p = point\\({int}, {int}, {int})") do |x, y, z|
  expect_tuple_equals(
    @inv * @p,
    point(x, y, z)
  )
end

Then("transform * v = v") do
  expect_tuple_equals(
    @transform * @v,
    @v
  )
end

Given("transform ← scaling\\({int}, {int}, {int})") do |x, y, z|
  @transform = scaling(x, y, z)
end

Then("transform * v = vector\\({int}, {int}, {int})") do |x, y, z|
  expect_tuple_equals(
    @transform * @v,
    vector(x, y, z)
  )
end

Then("inv * v = vector\\({int}, {int}, {int})") do |x, y, z|
  expect_tuple_equals(
    @inv * @v,
    vector(x, y, z)
  )
end

Given("half_quarter ← rotation\\({string}, π \/ {int})") do |axis, pi_fract|
  @hq = rotation(axis, Math::PI / pi_fract)
end

Given("full_quarter ← rotation\\({string}, π \/ {int})") do |axis, pi_fract|
  @fq = rotation(axis, Math::PI / pi_fract)
end


Then("half_quarter * p = point\\({string}, {string}, {string})") do |x, y, z|
  expect_tuple_equals(
    @hq * @p,
    point_from_strings(x, y, z)
  )
end

Then("full_quarter * p = point\\({int}, {int}, {int})") do |x, y, z|
  expect_tuple_equals(
    @fq * @p,
    point(x, y, z)
  )
end

Given("inv ← inverse\\(half_quarter)") do
  @inv = @hq.inverse
end

Then("inv * p = point\\({string}, {string}, {string})") do |x, y, z|
  expect_tuple_equals(
    @inv * @p,
    point_from_strings(x, y, z)
  )
end

Given("transform ← shearing\\({int}, {int}, {int}, {int}, {int}, {int})") do |sxy, sxz, syx, syz, szx, szy|
  @transform = shearing(sxy, sxz, syx, syz, szx, szy)
end

Given("M{int} ← rotation\\({string}, π \/ {num})") do |i, axis, pi_fract|
  m[i] = rotation(axis, Math::PI / pi_fract)
end

Given("M{int} ← scaling\\({num}, {num}, {num})") do |i, x, y, z|
  m[i] = scaling(x,y,z)
end

Given("M{int} ← translation\\({num}, {num}, {num})") do |i, x, y, z|
  m[i] = translation(x, y, z)
end

When("p{int} ← M{int} * p{int}") do |p_j, m_i, p_i|
  put(:p, p_j, m[m_i] * get(:p, p_i))
end

Then("p{int} = point\\({int}, {int}, {int})") do |i, x, y, z|
  expect_tuple_equals(
    get(:p, i),
    point(x, y, z)
  )
end

When("T ← M{int} * M{int} * M{int}") do |i, j, k|
  @t = m[i] * m[j] * m[k]
end

Then("T * p = point\\({int}, {int}, {int})") do |x, y, z|
  expect_tuple_equals(
    @t * @p,
    point(x, y, z)
  )
end