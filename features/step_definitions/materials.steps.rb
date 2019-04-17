module MaterialsHelper
end

World BaseHelper, MaterialsHelper

Given("m ← material") do
  @m = Material.new()
end

Then("m.color = {color}") do |color|
  expect_tuple_equals(@m.color, color)
end

Then("m.ambient = {num}") do |num|
  expect(@m.ambient).to eq(num)
end

Then("m.diffuse = {num}") do |num|
  expect(@m.diffuse).to eq(num)
end

Then("m.specular = {num}") do |num|
  expect(@m.specular).to eq(num)
end

Then("m.shininess = {num}") do |num|
  expect(@m.shininess).to eq(num)
end

Given("eyev ← {vector}") do |vector|
  @eye = vector
end

Given("normalv ← {vector}") do |vector|
  @normalv = vector
end

Given("eyev ← vector\\({num}, {frac}, {frac})") do |x, y, z|
  @eye = vector(x, y, z)
end


Given("light ← point_light\\({point}, {color})") do |point, color|
  @light = Light.point_light(point, color)
end

When("result ← lighting\\(m, light, position, eyev, normalv)") do
  @result = @m.lightning(@light, @position, @eye, @normalv)
end

Then("result = {color}") do |color|
  expect(@result).to eq(color)
end