module LightsHelper
  include BaseHelper
end

World LightsHelper


Given("intensity ← {color}") do |color|
  @intensity = color
end

Given("position ← {point}") do |point|
  @position = point
end

When("light ← point_light\\(position, intensity)") do
  @light = Light.point_light(@position, @intensity)
end

Then("light.position = position") do
  expect_tuple_equals(@light.position, @position)
end

Then("light.intensity = intensity") do
  expect_tuple_equals(@light.intensity, @intensity)
end