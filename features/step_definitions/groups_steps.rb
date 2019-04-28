module GroupsHelper
  def g
    @__g ||= {}
  end
end
World BaseHelper, GroupsHelper

Given('g ← group') do
  @g = Group.new
end

Then('g.transform = identity_matrix') do
  expect(@g.transform).to eq(identity_matrix)
end

Then('g is empty') do
  expect(@g.children.empty?).to be(true)
end

When('add_child\(g, s)') do
  @g << @s
end

Then('g is not empty') do
  expect(@g.children.empty?).to be(false)
end

Then('g includes s') do
  expect(@g.children.include?(@s)).to be(true)
end

Then('s.parent = g') do
  expect(@s.parent).to be(@g)
end

When('xs ← local_intersect\(g, r)') do
  @xs = @g.local_intersect(@r)
end

Given('set_transform\(s{int}, M{int})') do |i1, i2|
  s[i1].transform = m[i2]
end

Given('add_child\(g, s{int})') do |int|
  @g << s[int] # Write code here that turns the phrase above into concrete actions
end

Then('xs[{int}].object = s{int}') do |n, i|
  expect(@xs[n].object).to be(s[i]) # Write code here that turns the phrase above into concrete actions
end

Given('set_transform\(g, M{int})') do |int|
  @g.transform = m[int]
end

When('xs ← intersect\(g, r)') do
  @xs = @g.intersect(@r)
end

Given('g{int} ← group') do |int|
  g[int] = Group.new
end

Given('M{int} ← rotation\({string}, π\/{num})') do |i, axis, pi_frac|
  m[i] = Transformations.rotation(axis.to_sym, Math::PI / pi_frac)
end

Given('set_transform\(g{int}, M{int})') do |gi, mi|
  g[gi].transform = m[mi]
end

Given('add_child\(g{int}, g{int})') do |i, j|
  g[i] << g[j]
end

Given('set_transform\(s, M{int})') do |i|
  @s.transform = m[i]
end

Given('add_child\(g{int}, s)') do |i|
  g[i] << @s
end

When('p ← world_to_object\(s, {point})') do |point|
  @p = @s.world_to_object(point)
end

Then('p = {point}') do |point|
  expect(@p).to eps(point)
end

When('n ← normal_to_world\(s, {vector})') do |vector|
  @n = @s.normal_to_world(vector)
end

Then('g.bounds = s.bounds') do
  expect(@g.bounds).to eq(@s.bounds)
end

Given('s{int} ← test_shape') do |i|
  s[i] = TestShape.new
end

Then('g.bounds = [{point}, {point}]') do |top, bottom|
  expect(@g.bounds[0]).to eps(top)
  expect(@g.bounds[1]).to eps(bottom)
end

When('xs ← local_intersect_bounds\(g, r)') do
  @xs = @g.local_intersect_bounds(@r)
end

Then('xs[{int}].t = {frac}') do |i, frac|
end

Then('xs[{int}].t = {frac} + {num}') do |i, frac, num|
  expect(@xs[i].t).to eps(frac + num)
end

Then('g.hit_bounds\(r) = {bool}') do |bool|
  expect(@g.hit_bounds(@r)).to be(bool)
end

Given('s{int} ← shape') do |i|
  s[i] = Shape.new
end

Then('children intersections are not tested') do
  expect { @g.intersect(@r) }.not_to raise_error
end
