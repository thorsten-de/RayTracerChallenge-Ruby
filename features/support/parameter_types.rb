ParameterType(
  name: 'num',
  regexp: /-?\d+\.?\d*/,
  transformer: ->(num) { num.to_f }
)

ParameterType(
  name: 'vector',
  regexp: /vector\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
  transformer: ->(x, y, z) { Tuple.vector(x.to_f, y.to_f, z.to_f) }
)

ParameterType(
  name: 'point',
  regexp: /point\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
  transformer: ->(x, y, z) { Tuple.point(x.to_f, y.to_f, z.to_f) }
)

ParameterType(
  name: 'color',
  regexp: /color\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
  transformer: ->(x, y, z) { Tuple.color(x.to_f, y.to_f, z.to_f) }
)

ParameterType(
  name: 'tuple',
  regexp: /tuple\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
  transformer: ->(x, y, z, w) { Tuple.new([x.to_f, y.to_f, z.to_f, w.to_f]) }
)

ParameterType(
  name: 'frac',
  regexp: %r{(-?)√(\d+)/(\d+)},
  transformer: ->(sign, nom, den) { Math.sqrt(nom.to_f) / den.to_f * (sign == '-' ? -1 : 1) }
)

ParameterType(
  name: 'bool',
  regexp: /(false|False|true|True)/,
  transformer: ->(bool_str) { bool_str.casecmp('false').zero? ? false : true }
)
