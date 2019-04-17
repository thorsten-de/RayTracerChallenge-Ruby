module SphereHelper
  include BaseHelper


end

World SphereHelper



When("n ← normal_at\\(s, {point})") do |p|
  @n = @s.normal_at(p)
end

When("n ← normal_at\\(s, p)") do
  @n = @s.normal_at(@p)
end

When("p ← point\\({frac}, {frac}, {frac})") do |x, y, z|
  @p = point(x, y, z)
end

Then("n = vector\\({frac}, {frac}, {frac})") do |x, y, z|
  expect_tuple_equals(@n, vector(x, y, z))
end

Then("n = {vector}") do |v|
  expect_tuple_equals(@n, v)
end

Then("n = normalize\\(n)") do
  expect_tuple_equals(@n, @n.normalize)
end

Given("m ← M{int} * M{int}") do |i, j|
  @m = m[i] * m[j]
end

Given("n ← {vector}") do |v|
  @n = v
end

When("r ← reflect\\(v, n)") do
  @r = @v.reflect(@n)
end

Then("r = {vector}") do |v|
  expect_tuple_equals(@r,v )
end

Given("n ← vector\\({frac}, {frac}, {num})") do |x, y, z|
  @n = vector(x, y, z)
end

When("m ← s.material") do
  @m = @s.material
end

Then("m = material") do
   expect(@m).to eq(Material.new())
end

Given("m.ambient ← {num}") do |num|
  @m.ambient = num
end

When("s.material ← m") do
  @s.material = @m
end

Then("s.material = m") do
  expect(@s.material).to eq(@m)
end