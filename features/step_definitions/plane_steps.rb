module PlaneHelper
  def n
    @__n ||= {}
  end
end

World BaseHelper, PlaneHelper

Given('p ← plane') do
  @p = Plane.new
end

When('n{int} ← local_normal_at\(p, {point})') do |i, p|
  n[i] = @p.local_normal_at(p)
end

Then('n{int} = {vector}') do |i, v|
  expect(n[i]).to eq(v)
end

When('xs ← local_intersect\(p, r)') do
  @xs = @p.local_intersect(@r)
end

Then('xs is empty') do
  expect(@xs.empty?).to be(true)
end

Then('xs[{int}].object = p') do |i|
  expect(@xs[i].object).to be(@p)
end
