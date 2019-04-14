  module MatrixHelper
  include BaseHelper

  def matrix_mn(m, n, data)
    parsed_data = data
      .raw
      .flatten()
      .map(&:to_f)

    Matrix.new(m, n, parsed_data)
  end

  def matrix(data)
    raw = data.raw    
    matrix_mn(raw.length, raw[0].length, data)
  end

  def identity_matrix
    Matrix.identity_matrix(4)
  end

 
  def matrix_equals(a, b)
    a.all_values.zip(b.all_values).map {|ai, bi| expect(ai).to eps(bi)}
  end

  def matrix_not_equals(a, b)
    a.all_values.zip(b.all_values).map {|ai, bi| expect(ai).not_to eps(bi)}
  end
end

World MatrixHelper

Given("the following {int}x{int} matrix M:") do |m, n, table|
  # table is a Cucumber::MultilineArgument::DataTable
  @m = matrix_mn(m, n, table)
end

Given("the following {int}x{int} matrix A:") do |m, n, table|
  # table is a Cucumber::MultilineArgument::DataTable
  @a = matrix_mn(m, n, table)
end

Then("M[{int},{int}] = {int}") do |i, j, value|
  expect(@m[i,j]).to eq(value)
end

Then("M[{int},{int}] = {float}") do |i, j, value|
  expect(@m[i,j]).to eq(value)
end

Given("the following matrix A:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  @a = matrix(table)
end

Given("the following matrix B:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  @b = matrix(table)
end

Then("A = B") do
  matrix_equals(@a, @b)

end

Then("A != B") do
  matrix_not_equals(@a, @b)
end

Then("A * B is the following {int}x{int} matrix:") do |int, int2, table|
  # table is a Cucumber::MultilineArgument::DataTable
  matrix_equals(
    @a * @b,
    matrix(table)
  )
end

Given('b ← tuple\({float}, {float}, {float}, {float})') do |x, y, z, w|
  @b = tuple(x, y, z, w)
end

Then('A * b = tuple\({float}, {float}, {float}, {float})') do |x, y, z, w|
  expect_tuple_equals(
    @a * @b,
    tuple(x, y, z, w)
  )
end

Then("A * identity_matrix = A") do
  matrix_equals(
    @a * identity_matrix,
    @a
  )
end


Then("identity_matrix * a = a") do
  expect_tuple_equals(
    identity_matrix * @a,
    @a
  )
end

Then('transpose\(A) is the following matrix:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  matrix_equals(
    @a.transpose,
    matrix(table)
  ) # Write code here that turns the phrase above into concrete actions
end

Given('A ← transpose\(identity_matrix)') do
  @A = identity_matrix.transpose 
end

Then("A = identity_matrix") do
  matrix_equals(
    @A,
    identity_matrix
  )
end

Then('determinant\(M) = {int}') do |det|
  expect(@m.determinant).to eq(det)
end

Then('submatrix\(M, {int}, {int}) is the following {int}x{int} matrix:') do |row, col, int3, int4, table|
  # table is a Cucumber::MultilineArgument::DataTable
  matrix_equals(
    @m.submatrix(row, col),
    matrix(table)
  )
end


Given('M ← submatrix\(A, {int}, {int})') do |row, col|
  @m = @a.submatrix(row, col)
end

Then('minor\(A, {int}, {int}) = {int}') do |row, col, expected|
  expect(@a.minor(row, col)).to eq(expected)
end

Then('cofactor\(A, {int}, {int}) = {int}') do |row, col, expected|
  expect(@a.cofactor(row, col)).to eq(expected)
end


Then('determinant\(A) = {int}') do |expected|
  expect(@a.determinant).to eq(expected)
end

Then("A is invertible") do
  expect(@a.invertible?).to be(true)
end

Then("A is not invertible") do
  expect(@a.invertible?).to be(false)
end


Given('B ← inverse\(A)') do
  @B = @a.inverse
end

Then('B[{int},{int}] = {int}\/{int}') do |i, j, num, den|
  expect(@B[i, j]).to eq(num.to_f/den.to_f)
end

Then('B is the following {int}x{int} matrix:') do |m, n, table|
  # table is a Cucumber::MultilineArgument::DataTable
  matrix_equals(
    @B,
    matrix_mn(m, n, table)
  )
end

Then('inverse\(A) is the following {int}x{int} matrix:') do |m, n, table|
  # table is a Cucumber::MultilineArgument::DataTable
  matrix_equals(
    @a.inverse,
    matrix_mn(m, n, table)
  )
end

Given('the following {int}x{int} matrix B:') do |m, n, table|
  # table is a Cucumber::MultilineArgument::DataTable
  @B = matrix_mn(m, n, table)
end

Given("C ← A * B") do
  @C = @a * @B
end

Then('C * inverse\(B) = A') do
  matrix_equals(
    @C * @B.inverse,
    @a
  )
end