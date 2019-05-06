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

Given('n{int} ← {vector}') do |i, vector|
  n[i] = vector
end

When('t ← smooth_triangle\(p{int}, p{int}, p{int}, n{int}, n{int}, n{int})') do |_p1, _p2, _p3, n1, n2, n3|
  @t = SmoothTriangle.new([p[1], p[2], p[3]],
                          normals: [n[n1], n[n2], n[n3]])
end

Then('t.n{int} = n{int}') do |ti, ni|
  expect(@t.n[ti - 1]).to eq(n[ni])
end

Then('xs[{int}].u = {num}') do |i, u|
  expect(@xs[i].u).to eps(u)
end

Then('xs[{int}].v = {num}') do |i, v|
  expect(@xs[i].v).to eps(v)
end

When('i ← intersection_with_uv\({num}, t, {num}, {num})') do |t, u, v|
  @i = Intersection.new(t, @t, u, v)
end

When('n ← normal_at\(t, {point}, i)') do |point|
  @n = @t.normal_at(point, @i)
end
