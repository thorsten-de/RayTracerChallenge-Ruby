module RayHelper
  include BaseHelper

  def ray(origin, direction)
    Ray.new(origin, direction)
  end

  def sphere 
    Sphere.new()
  end
end

World RayHelper

When("r ← ray\\(p, v)") do
  @r = ray(@p, @v)
end

Then("r.origin = origin") do
  expect_tuple_equals(@r.origin, @p)
end

Then("r.direction = direction") do
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

Given("s ← sphere") do
  @s = sphere()
end

When("xs ← intersect\\(s, r)") do
  @xs = @r.intersect(@s)
end

Then("xs.count = {num}") do |num|
  expect(@xs.length).to eq(num)
end

Then("xs[{int}] = {num}") do |i, num|
  expect(@xs[i]).to eq(num)
end

When("i ← intersection\\({num}, s)") do |t|
  @i = Intersection.new(t, @s)
end

Then("i.t = {num}") do |num|
  expect(@i.t).to eq(num)
end

Then("i.object = s") do
  expect(@i.object).to eq(@s)
end