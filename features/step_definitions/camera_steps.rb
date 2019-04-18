World BaseHelper

Given('hsize ← {int}') do |int|
  @hsize = int
end

Given('vsize ← {int}') do |int|
  @vsize = int
end

Given('field_of_view ← π\/{num}') do |pi_frac|
  @fov = Math::PI / pi_frac
end

When('c ← camera\(hsize, vsize, field_of_view)') do
  @c = Camera.new(@hsize, @vsize, @fov)
end

Then('c.hsize = {int}') do |int|
  expect(@c.hsize).to eq(int)
end

Then('c.vsize = {int}') do |int|
  expect(@c.vsize).to eq(int)
end

Then('c.field_of_view = π\/{num}') do |pi_frac|
  expect(@c.field_of_view).to eq(Math::PI / pi_frac)
end

Then('c.transform = identity_matrix') do
  matrix_equals(@c.transform, identity_matrix)
end

Given('c ← camera\({int}, {int}, π\/{num})') do |v, h, pi_frac|
  @c = Camera.new(v, h, Math::PI / pi_frac)
end

Then('c.pixel_size = {float}') do |float|
  expect(@c.pixel_size).to eps(float)
end

When('r ← ray_for_pixel\(c, {int}, {int})') do |x, y|
  @r = @c.ray_for_pixel(x, y)
end

Then('r.origin = {point}') do |point|
  expect_tuple_equals(@r.origin, point)
end

Then('r.direction = {vector}') do |vector|
  expect_tuple_equals(@r.direction, vector)
end

Given('c.transform ← view_transform\(from, to, up)') do
  @c.transform = Transformations.view_transform(@from, @to, @up)
end

When('image ← render\(c, w)') do
  @image = @c.render(@w)
end

Then('pixel_at\(image, {int}, {int}) = {color}') do |px, py, color|
  expect_tuple_equals(@image[px, py], color)
end
