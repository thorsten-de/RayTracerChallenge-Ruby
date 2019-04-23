World BaseHelper

When('comps ← prepare_computations\(i, r)') do
  @comps = @r.prepare_computations(@i)
end

Then('comps.t = i.t') do
  expect(@comps.t).to eq(@i.t)
end

Then('comps.object = i.object') do
  expect(@comps.object).to eq(@i.object)
end

Then('comps.point = {point}') do |point|
  expect(@comps.point).to eq(point)
end

Then('comps.eyev = {vector}') do |vector|
  expect(@comps.eyev).to eq(vector)
end

Then('comps.normalv = {vector}') do |vector|
  expect(@comps.normalv).to eq(vector)
end

Then('comps.inside = false') do
  expect(@comps.inside).to be(false)
end

Then('comps.inside = true') do
  expect(@comps.inside).to be(true)
end

Then('comps.over_point.z < -EPSILON\/2') do
  expect(@comps.over_point.z).to be < -EPSILON / 2
end

Then('comps.point.z > comps.over_point.z') do
  expect(@comps.point.z).to be > @comps.over_point.z
end

Then('comps.reflectv = {vector}') do |vector|
  expect(@comps.reflectv).to eq(vector)
end

Given('xs ← intersections\(i)') do
  @xs = [@i]
end

When('comps ← prepare_computations\(i, r, xs)') do
  @comps = @r.prepare_computations(@i, @xs)
end

Then('comps.under_point.z > EPSILON\/2') do
  expect(@comps.under_point.z).to be > EPSILON / 2
end

Then('comps.point.z < comps.under_point.z') do
  expect(@comps.point.z).to be < @comps.under_point.z
end
