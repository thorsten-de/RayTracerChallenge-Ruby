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
