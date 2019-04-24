World BaseHelper

Given('cyl ← cylinder') do
  @cyl = Cylinder.new
end

Given('direction ← normalize\({vector})') do |vector|
  @direction = vector.normalize
end

Given('r ← ray\({point}, direction)') do |point|
  @r = Ray.new(point, @direction)
end

When('xs ← local_intersect\(cyl, r)') do
  @xs = @cyl.local_intersect(@r)
end

When('n ← local_normal_at\(cyl, {point})') do |point|
  @n = @cyl.local_normal_at(point)
end

Then('cyl.minimum = -infinity') do
  expect(@cyl.minimum).to eq(-Float::INFINITY)
end

Then('cyl.maximum = infinity') do
  expect(@cyl.maximum).to eq(Float::INFINITY)
end

Given('cyl.minimum ← {num}') do |num|
  @cyl.minimum = num
end

Given('cyl.maximum ← {num}') do |num|
  @cyl.maximum = num
end
