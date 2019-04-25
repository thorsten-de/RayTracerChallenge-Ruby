World BaseHelper

Given('shape ← cylinder') do
  @shape = Cylinder.new
end

Given('direction ← normalize\({vector})') do |vector|
  @direction = vector.normalize
end

Given('r ← ray\({point}, direction)') do |point|
  @r = Ray.new(point, @direction)
end

When('xs ← local_intersect\(shape, r)') do
  @xs = @shape.local_intersect(@r)
end

When('n ← local_normal_at\(shape, {point})') do |point|
  @n = @shape.local_normal_at(point)
end

Then('shape.minimum = -infinity') do
  expect(@shape.minimum).to eq(-Float::INFINITY)
end

Then('shape.maximum = infinity') do
  expect(@shape.maximum).to eq(Float::INFINITY)
end

Given('shape.minimum ← {num}') do |num|
  @shape.minimum = num
end

Given('shape.maximum ← {num}') do |num|
  @shape.maximum = num
end

Then('shape.closed = {bool}') do |bool|
  expect(@shape.closed).to be(bool)
end

Given('shape.closed ← {bool}') do |bool|
  @shape.closed = bool
end
