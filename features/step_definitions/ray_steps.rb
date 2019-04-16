module RayHelper
  include BaseHelper

  def ray(origin, direction)
    Ray.new(origin, direction)
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

Given("r ← ray\\(point\\({int}, {int}, {int}), vector\\({int}, {int}, {int}))") do |p_x, p_y, p_z, v_x, v_y, v_z|
  @r = ray(point(p_x, p_y, p_z), vector(v_x, v_y, v_z))
end

Then('position\(r, {float}) = point\({float}, {int}, {int})') do |t, x, y, z|
  expect_tuple_equals(
    @r.position(t),
    point(x, y, z)
  )
end