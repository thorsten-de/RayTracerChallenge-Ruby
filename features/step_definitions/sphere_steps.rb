module SphereHelper
  include BaseHelper

  def glass_sphere
    Sphere.new(material: Material.new(transparency: 1.0, refractive_index: 1.5))
  end
end

World SphereHelper

When('n ← normal_at\\(s, {point})') do |p|
  @n = @s.normal_at(p)
end

When('n ← normal_at\\(s, p)') do
  @n = @s.normal_at(@p)
end

Then('n = {vector}') do |v|
  expect_tuple_equals(@n, v)
end

Then('n = normalize\\(n)') do
  expect_tuple_equals(@n, @n.normalize)
end

Given('m ← M{int} * M{int}') do |i, j|
  @m = m[i] * m[j]
end

Given('n ← {vector}') do |v|
  @n = v
end

When('r ← reflect\\(v, n)') do
  @r = @v.reflect(@n)
end

Then('r = {vector}') do |v|
  expect_tuple_equals(@r, v)
end

When('m ← s.material') do
  @m = @s.material
end

Then('m = material') do
  expect(@m).to eq(Material.new)
end

Given('m.ambient ← {num}') do |num|
  @m.ambient = num
end

When('s.material ← m') do
  @s.material = @m
end

Then('s.material = m') do
  expect(@s.material).to eq(@m)
end

Given('s ← glass_sphere') do
  @s = glass_sphere
end

Then('s.material.transparency = {num}') do |num|
  expect(@s.material.transparency).to eq(num)
end

Then('s.material.refractive_index = {num}') do |num|
  expect(@s.material.refractive_index).to eq(num)
end

Given('A ← glass_sphere with:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  @A = glass_sphere
  read_property_table(@A, table)
end

Given('B ← glass_sphere with:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  @B = glass_sphere
  read_property_table(@B, table)
end

Given('C ← glass_sphere with:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  @C = glass_sphere
  read_property_table(@C, table)
end

Given('xs ← intersections\({num}:A, {num}:B, {num}:C, {num}:B, {num}:C, {num}:A)') do |t1, t2, t3, t4, t5, t6|
  @xs = [
    Intersection.new(t1, @A),
    Intersection.new(t2, @B),
    Intersection.new(t3, @C),
    Intersection.new(t4, @B),
    Intersection.new(t5, @C),
    Intersection.new(t6, @A)
  ]
end

When('comps ← prepare_computations\(xs[{int}], r, xs)') do |i|
  @comps = @r.prepare_computations(@xs[i], @xs)
end

Then('comps.n1 = {num}') do |num|
  expect(@comps.n1).to eq(num)
end

Then('comps.n2 = {num}') do |num|
  expect(@comps.n2).to eq(num)
end
