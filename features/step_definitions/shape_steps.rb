World BaseHelper

Given('s ← test_shape') do
  @s = TestShape.new
end

Then('s.transform = translation\({num}, {num}, {num})') do |x, y, z|
  matrix_equals(@s.transform, translation(x, y, z))
end

Then('s.saved_ray.origin = {point}') do |point|
  expect(@s.saved_ray.origin).to eq(point)
end

Then('s.saved_ray.direction = {vector}') do |vector|
  expect(@s.saved_ray.direction).to eq(vector)
end
