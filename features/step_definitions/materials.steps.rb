module MaterialsHelper
  def c
    (@__c ||= {})
    end
end

World BaseHelper, MaterialsHelper

Given('m ← material') do
  @m = Material.new
end

Then('m.color = {color}') do |color|
  expect_tuple_equals(@m.color, color)
end

Then('m.ambient = {num}') do |num|
  expect(@m.ambient).to eq(num)
end

Then('m.diffuse = {num}') do |num|
  expect(@m.diffuse).to eq(num)
end

Then('m.specular = {num}') do |num|
  expect(@m.specular).to eq(num)
end

Then('m.shininess = {num}') do |num|
  expect(@m.shininess).to eq(num)
end

Given('normalv ← {vector}') do |vector|
  @normalv = vector
end

Given('eyev ← {vector}') do |v|
  @eye = v
end

Given('light ← point_light\\({point}, {color})') do |point, color|
  @light = Light.point_light(point, color)
end

When('result ← lighting\\(m, light, position, eyev, normalv)') do
  @result = PhongShader.lightning(@m, TestShape.new, @light, @position, @eye, @normalv)
end

Then('result = {color}') do |color|
  expect_tuple_equals(@result, color)
end
Given('in_shadow ← true') do
  @in_sahdow = true
end

When('result ← lighting\(m, light, position, eyev, normalv, in_shadow)') do
  @result = PhongShader.lightning(@m, TestShape.new, @light, @position, @eye, @normalv, @in_sahdow)
end

Given('m.pattern ← stripe_pattern\({color}, {color})') do |c1, c2|
  @m.pattern = stripe_pattern(c1, c2)
end

Given('m.diffuse ← {num}') do |num|
  @m.diffuse = num
end

Given('m.specular ← {num}') do |num|
  @m.specular = num
end

When('c{int} ← lighting\(m, light, {point}, eyev, normalv, {bool})') do |i, p, in_shadow|
  c[i] = PhongShader.lightning(@m, TestShape.new, @light, p, @eye, @normalv, in_shadow)
end

Then('c{int} = {color}') do |i, color|
  expect(c[i]).to eq(color)
end

Then('m.reflective = {num}') do |num|
  expect(@m.reflective).to eq(num)
end

Given('r ← ray\({point}, v)') do |origin|
  @r = Ray.new(origin, @v)
end

Given('shape ← plane') do
  @shape = Plane.new
end

Given('i ← intersection\({frac}, shape)') do |t|
  @i = Intersection.new(t, @shape)
end

Then('m.transparency = {num}') do |num|
  expect(@m.transparency).to eq(num)
end

Then('m.refractive_index = {num}') do |num|
  expect(@m.refractive_index).to eq(num)
end
