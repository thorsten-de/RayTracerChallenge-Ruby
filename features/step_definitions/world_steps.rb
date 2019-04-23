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
    'material.ambient' => ->(obj, value) { obj.material.ambient = value.to_f },
    'material.diffuse' => ->(obj, value) { obj.material.diffuse = value.to_f },
    'material.specular' => ->(obj, value) { obj.material.specular = value.to_f },
    'material.reflective' => ->(obj, value) { obj.material.reflective = value.to_f },
    'material.refractive_index' => ->(obj, value) { obj.material.refractive_index = value.to_f },
    'material.transparency' => ->(obj, value) { obj.material.transparency = value.to_f },
    'material.pattern' => lambda { |obj, _value|
      obj.material.pattern = Pattern.test_pattern
    },
    'material.color' => lambda { |obj, tuple|
                          r, g, b = str_to_f(tuple)
                          obj.material.color = Tuple.color(r, g, b)
                        },
    'transform' => lambda { |obj, tuple|
      x, y, z = str_to_f(tuple)
      obj.transform = if tuple.start_with?('translation')
                        Transformations.translation(x, y, z)
                      elsif tuple.start_with?('scaling')
                        Transformations.scaling(x, y, z)
                      end
    }
  }.freeze

  def set_property(object, key, value)
    PROPERTY_SETTERS[key].call(object, value)
  end

  def read_property_table(obj, table)
    table.rows_hash.each { |key, value| set_property(obj, key, value) }
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
  # expect_tuple_equals(@c, color)
  expect(@c).to eps(color)
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

Then('is_shadowed\(w, p) is {bool}') do |bool|
  expect(@w.is_shadowed(@p)).to be(bool)
end

Given('s{int} ← sphere') do |int|
  s[int] = Sphere.new
end

Given('s{int} is added to w') do |int|
  @w.objects << s[int]
end

Given('i ← intersection\({num}, s{int})') do |t, int|
  @i = Intersection.new(t, s[int])
end

Given('s.material.ambient ← {num}') do |num|
  @s.material.ambient = num
end

When('c ← reflected_color\(w, comps)') do
  @c = @w.reflected_color(@comps)
end

Given('shape ← plane with:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  @shape = Plane.new
  data = table.rows_hash
  data.each { |key, value| set_property(@shape, key, value) }
end

Given('shape is added to w') do
  @w.objects << @shape
end

Given('s{int} ← plane with:') do |i, table|
  # table is a Cucumber::MultilineArgument::DataTable
  data = table.rows_hash
  s[i] = sp = Plane.new
  data.each { |key, value| set_property(sp, key, value) }
end

Then('color_at\(w, r) should terminate successfully') do
  expect { @w.color_at(@r) }.not_to raise_error
end

When('c ← reflected_color\(w, comps, {int})') do |int|
  @c = @w.reflected_color(@comps, int)
end

Given('shape ← the first object in w') do
  @shape = @w.objects.first
end

Given('xs ← intersections\({int}:shape, {int}:shape)') do |t1, t2|
  @xs = [
    Intersection.new(t1, @shape),
    Intersection.new(t2, @shape)
  ]
end

When('c ← refracted_color\(w, comps, {int})') do |i|
  @c = @w.refracted_color(@comps, i)
end

Given('shape has:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  read_property_table(@shape, table)
end

Given('xs ← intersections\({frac}:shape, {frac}:shape)') do |t1, t2|
  @xs = [
    Intersection.new(t1, @shape),
    Intersection.new(t2, @shape)
  ]
end

Given('A ← the first object in w') do
  @a = @w.objects[0]
end

Given('A has:') do |table|
  read_property_table(@a, table)
end

Given('B ← the second object in w') do
  @b = @w.objects[1]
end

Given('B has:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  read_property_table(@b, table)
end

Given('xs ← intersections\({num}:A, {num}:B, {num}:B, {num}:A)') do |t1, t2, t3, t4|
  @xs = [
    Intersection.new(t1, @a),
    Intersection.new(t2, @b),
    Intersection.new(t3, @b),
    Intersection.new(t4, @a)
  ]
end

Given('floor ← plane with:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  @floor = Plane.new
  read_property_table(@floor, table)
end

Given('floor is added to w') do
  @w.objects << @floor
end

Given('ball ← sphere with:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  @ball = Sphere.new
  read_property_table(@ball, table)
end

Given('ball is added to w') do
  @w.objects << @ball
end

Given('xs ← intersections\({frac}:floor)') do |t|
  @xs = [
    Intersection.new(t, @floor)
  ]
end

When('c ← shade_hit\(w, comps, {int})') do |int|
  @c = @w.shade_hit(@comps, int)
end
