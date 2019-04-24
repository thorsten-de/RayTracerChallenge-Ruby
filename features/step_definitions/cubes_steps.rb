World BaseHelper

Given('c ← cube') do
  @c = Cube.new
end

When('xs ← local_intersect\(c, r)') do
  @xs = @c.local_intersect(@r)
end

When('normal ← local_normal_at\(c, p)') do
  @normal = @c.local_normal_at(@p)
end

Then('normal = {vector}') do |vector|
  expect(@normal).to eps(vector)
end
