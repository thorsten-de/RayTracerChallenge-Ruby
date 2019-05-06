module ObjFileHelper
  def t
    (@__t ||= {})
  end
end
World BaseHelper, ObjFileHelper

Given('gibberish ← a file containing:') do |string|
  @gibberish = StringIO.new(string)
end

When('parser ← parse_obj_file\(gibberish)') do
  @parser = ObjFile.parse(@gibberish)
end

Then('parser should have ignored {int} lines') do |int|
  expect(@parser.ignored_lines).to eq(int)
end

Given('file ← a file containing:') do |string|
  @file = StringIO.new(string)
end

When('parser ← parse_obj_file\(file)') do
  @parser = ObjFile.parse(@file)
end

Then('parser.vertices[{int}] = {point}') do |int, point|
  expect(@parser.vertices[int]).to eq(point)
end
When('g ← parser.default_group') do
  @g = @parser.default_group
end

When('t{int} ← first child of g') do |i|
  t[i] = @g.children[0]
end

When('t{int} ← second child of g') do |i|
  t[i] = @g.children[1]
end

When('t{int} ← third child of g') do |i|
  t[i] = @g.children[2]
end

Then('t{int}.p{int} = parser.vertices[{int}]') do |ti, pi, vi|
  expect(t[ti].p[pi - 1]).to eq(@parser.vertices[vi])
end

Given('file ← the file {string}') do |filename|
  @file = File.open("files/#{filename}")
end

When('g{int} ← {string} from parser') do |i, name|
  g[i] =  @parser.groups[name]
end

When('t{int} ← first child of g{int}') do |ti, gi|
  # When("t{int} ← first child of g{num}") do |int, num|
  # When("t{num} ← first child of g{int}") do |num, int|
  # When("t{num} ← first child of g{num}") do |num, num2|
  t[ti] = g[gi].children.first
end

When('g ← obj_to_group\(parser)') do
  @g = @parser.obj_to_group
end

Then('g includes {string} from parser') do |name|
  expect(@g.children).to include(@parser.groups[name])
end

Then('parser.normals[{int}] = {vector}') do |int, vector|
  expect(@parser.normals[int]).to eq(vector)
end

Then('t{int}.n{int} = parser.normals[{int}]') do |ti, ni, j|
  expect(t[ti].n[ni - 1]).to eq(@parser.normals[j])
end

Then('t{int} = t{int}') do |i1, i2|
  expect(t[i1].p).to eq(t[i2].p)
  expect(t[i1].n).to eq(t[i2].n)
end
