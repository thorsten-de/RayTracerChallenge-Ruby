module PatternsHelper
  def stripe_pattern(a, b)
    Pattern.stripes(a, b)
  end
end

World BaseHelper, PatternsHelper

Given('black ← {color}') do |_color|
  @black = color(0, 0, 0)
end

Given('white ← {color}') do |_color|
  @white = color(1, 1, 1)
end

Given('pattern ← stripe_pattern\(white, black)') do
  @pattern = stripe_pattern(@white, @black)
end

Then('pattern.a = white') do
  expect(@pattern.a).to eq(@white)
end

Then('pattern.b = black') do
  expect(@pattern.b).to eq(@black)
end

Then('pattern_at\(pattern, {point}) = white') do |point|
  expect(@pattern.pattern_at(point)).to eq(@white)
end

Then('pattern_at\(pattern, {point}) = black') do |point|
  expect(@pattern.pattern_at(point)).to eq(@black)
end

When('c ← pattern_at_shape\(pattern, s, {point})') do |point|
  @c = @pattern.pattern_at_shape(@s, point)
end

Then('c = white') do
  expect(@c).to eq(@white)
end

Given('set_pattern_transform\(pattern, M{int})') do |i|
  @pattern.transform = m[i]
end

Given('pattern ← test_pattern') do
  @pattern = Pattern.test_pattern
end

Then('pattern.transform = identity_matrix') do
  expect(@pattern.transform).to eq(identity_matrix)
end

Then('pattern.transform = M{int}') do |i|
  expect(@pattern.transform).to eq(m[i])
end

Given('pattern ← gradient_pattern\(white, black)') do
  @pattern = Pattern.gradient(@white, @black)
end

Then('pattern_at\(pattern, {point}) = {color}') do |point, color|
  expect(@pattern.pattern_at(point)).to eq(color)
end

Given('pattern ← ring_pattern\(white, black)') do
  @pattern = Pattern.ring(@white, @black)
end

Given('pattern ← checkers_pattern\(white, black)') do
  @pattern = Pattern.checkers(@white, @black)
end
