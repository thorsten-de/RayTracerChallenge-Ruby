World BaseHelper

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
