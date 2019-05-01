module TrianglesHelper
end

World BaseHelper, TrianglesHelper

Given('t ← triangle\(p{int}, p{int}, p{int})') do |i1, i2, i3|
  @t = Triangle.new([p[i1], p[i2], p[i3]])
end

Then('t.p{int} = p{int}') do |ti, i|
  expect(@t.p[ti - 1]).to eq(p[i])
end

Then('t.e{int} = {vector}') do |int, vector|
  expect(@t.e[int - 1]).to eq(vector)
end

Then('t.normal = {vector}') do |vector|
  expect(@t.normal).to eq(vector)
end

Given('t ← triangle\({point}, {point}, {point})') do |p1, p2, p3|
  @t = Triangle.new([p1, p2, p3])
end

When('n{int} ← local_normal_at\(t, {point})') do |i, point|
  n[i] = @t.local_normal_at(point)
end

Then('n{int} = t.normal') do |i|
  expect(n[i]).to eq(@t.normal)
end

When('xs ← local_intersect\(t, r)') do
  @xs = @t.local_intersect(@r)
end
