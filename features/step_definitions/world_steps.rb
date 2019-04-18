module WorldHelper
  include BaseHelper

  def s
    (@_s ||= {})
  end

  def world_contains?(s)
    @w.objects.include?(s)
  end

  def self.str_to_f(str)
    str.split(/[,\(\)]\s*/)
       .map(&:to_f)
       .drop(1)
  end

  PROPERTY_SETTERS = {
    'material.diffuse' => ->(obj, value) { obj.material.diffuse = value.to_f },
    'material.specular' => ->(obj, value) { obj.material.specular = value.to_f },
    'material.color' => lambda { |obj, tuple|
                          r, g, b = str_to_f(tuple)
                          obj.material.color = Tuple.color(r, g, b)
                        },
    'transform' => lambda { |obj, tuple|
      x, y, z = str_to_f(tuple)
      obj.transform = Transformations.scaling(x, y, z)
    }
  }.freeze

  def set_property(object, key, value)
    PROPERTY_SETTERS[key].call(object, value)
  end
end

World WorldHelper

Given('w ← world') do
  @w = World.new
end

Then('w contains no objects') do
  expect(@w.objects).to eq([])
end

Then('w has no light source') do
  expect(@w.light).to eq(nil)
end

Given('s{int} ← sphere with:') do |i, table|
  data = table.rows_hash
  s[i] = sp = Sphere.new
  data.each { |key, value| set_property(sp, key, value) }
end

When('w ← default_world') do
  @w = World.default
end

Then('w.light = light') do
  expect(@w.light).to eq(@light)
end

Then('w contains s{int}') do |i|
  expect(@w.contains?(s[i])).to be(true)
end

When('xs ← intersect_world\(w, r)') do
  @xs = @w.intersect(@r)
end

Given('s ← the first object in w') do
  @s = @w.objects[0]
end

When('c ← shade_hit\(w, comps)') do
  @c = @w.shade_hit(@comps)
end

Then('c = {color}') do |color|
  expect_tuple_equals(@c, color)
end

Given('w.light ← point_light\({point}, {color})') do |point, color|
  @w.lights = [Light.point_light(point, color)]
end

Given('s ← the second object in w') do
  @s = @w.objects[1]
end

When('c ← color_at\(w, r)') do
  @c = @w.color_at(@r)
end

Given('outer ← the first object in w') do
  @outer = @w.objects[0]
end

Given('outer.material.ambient ← {num}') do |num|
  @outer.material.ambient = num
end

Given('inner ← the second object in w') do
  @inner = @w.objects[1]
end

Given('inner.material.ambient ← {num}') do |num|
  @inner.material.ambient = num
end

Then('c = inner.material.color') do
  expect_tuple_equals(@c, @inner.material.color)
end
