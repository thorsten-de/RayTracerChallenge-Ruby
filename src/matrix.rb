class Matrix
  def initialize(m, n, data = nil)
    @m = m
    @n = n
    @data = data || if block_given?
                      Array.new(m * n) do |i|
                        yield(i / n, i % n)
                      end
                    else
                      Array.new(m * n)
    end
  end

  attr_reader :m

  attr_reader :n

  def [](i, j)
    @data[@n * i + j]
  end

  def []=(i, j, value)
    @data[@n * i + j] = value
  end

  def all_values
    @data
  end

  TO_MATRIX = {
    Matrix => ->(m) { m },
    Tuple => ->(t) { t.to_matrix }
  }.freeze

  FROM_MATRIX = {
    Matrix => ->(m) { m },
    Tuple => ->(m) { m.to_tuple }
  }.freeze

  def *(other)
    for_class = other.class
    b = TO_MATRIX[for_class].call(other)
    throw "Matrix A hat #{n} Spalten, aber Matrix B #{b.m} Zeilen." if n != b.m

    m = self.m
    n = b.n

    result = Matrix.new(m, n) do |row, col|
      (0..@n - 1).map { |k| self[row, k] * b[k, col] }.sum
    end

    FROM_MATRIX[for_class].call(result)
  end

  def transpose
    Matrix.new(@n, @m) do |row, col|
      self[col, row]
    end
  end

  def determinant
    det = 0
    det = self[0, 0] * self[1, 1] - self[0, 1] * self[1, 0] if @m == 2
    if @m > 2
      (0..@n - 1).each do |col|
        det += self[0, col] * cofactor(0, col)
      end
    end
    det
  end

  def invertible?
    determinant != 0
  end

  def inverse
    det_M = determinant

    throw 'Not invertiable' if det_M == 0

    Matrix.new(@n, @m) do |row, col|
      c = cofactor(col, row)
      c / det_M
    end
  end

  def submatrix(row_to_remove, col_to_remove)
    Matrix.new(@m - 1, @n - 1) do |row, col|
      self[
        row >= row_to_remove ? row + 1 : row,
        col >= col_to_remove ? col + 1 : col
       ]
    end
  end

  def minor(row, col)
    submatrix(row, col).determinant
  end

  def cofactor(row, col)
    if (row + col).odd?
      -minor(row, col)
    else
      minor(row, col)
    end
  end

  def to_s
    "<#{@m}x#{@n}-Matrix>"
  end

  def inspect
    @data
      .each_slice(@n)
      .map { |row| "\n| " << row.map { |value| format('%9.5f', value) }.join(' | ') << ' |' }
      .join << "\n"
  end

  def to_matrix
    self
  end

  def to_tuple
    throw 'Nur 4x1-Matrix kann in Tupel umgewandelt werden' unless (@m == 4) && (@n == 1)
    Tuple.new(@data)
  end

  def self.identity_matrix(n)
    identity_matrix = Matrix.new(n, n, Array.new(n * n, 0.0))
    (0..n - 1).each do |i|
      identity_matrix[i, i] = 1.0
    end

    identity_matrix
  end

  def self.identity
    identity_matrix(4)
  end

  def self.I
    identity
  end

  def rotate(axis, r)
    Transformations.rotation(axis, r) * self
  end

  def scale(sx, sy, sz)
    Transformations.scaling(sx, sy, sz) * self
  end

  def translate(x, y, z)
    Transformations.translation(x, y, z) * self
  end

  def ==(other)
    @data == other.all_values
  end
end
