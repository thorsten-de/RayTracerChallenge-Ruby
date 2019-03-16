require_relative '../../raytracer.rb'
#require_relative 'tuples_steps'

module CanvasHelper
  include BaseHelper

  def canvas(w, h)
    Canvas.new(w, h)
  end

end

World CanvasHelper

Given('c ← canvas\({int}, {int})') do |width, height|
  @c = canvas(width, height)
end

Then("c.width = {int}") do |expected_width|
  expect(@c.width).to eq(expected_width)
end

Then("c.height = {int}") do |expected_height|
  expect(@c.height).to eq(expected_height)
end

Then('every pixel of c is color\({float}, {float}, {float})') do |r, g, b|
  expected_color = color(r, g, b)
  @c.all_pixel.each do |c|
    expect_tuple_equals(c, expected_color)
  end
end

Given('red ← color\({float}, {float}, {float})') do |r, g, b|
  @red = color(r, g, b)
end

When('write_pixel\(c, {int}, {int}, red)') do |x, y|
  @c[x, y] = @red
end

Then('pixel_at\(c, {int}, {int}) = red') do |x, y|
  expect_tuple_equals(
    @c[x, y],
    @red
  )
end

When('ppm ← canvas_to_ppm\(c)') do
  @ppm = @c.to_ppm
end

Then("lines {int}-{int} of ppm are") do |from, to, doc|
  range = (from-1) .. (to-1)
  lines = @ppm.split("\n").slice(range)
  expect(lines.join("\n")).to eq(doc)
end

When('write_pixel\(c, {int}, {int}, c{int})') do |x, y, i|
  @c[x, y] = get(:c, i)
end

When('every pixel of c is set to color\({float}, {float}, {float})') do |r, g, b|
  @c.all_pixel = color(r, g, b)
end
  
Then('ppm ends with a newline character') do
  expect(@ppm[-1]).to eq("\n")
end