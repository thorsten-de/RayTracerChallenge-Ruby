ParameterType(
    name: 'num',
    regexp: /-?\d+\.?\d*/,
    transformer: -> (num) {num.to_f}
)

ParameterType(
    name: 'vector',
    regexp: /vector\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
    transformer: -> (x, y, z) { Tuple.vector(x.to_f, y.to_f, z.to_f)}
)

ParameterType(
    name: 'point',
    regexp: /point\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
    transformer: -> (x, y, z) { Tuple.point(x.to_f, y.to_f, z.to_f)}
)
ParameterType(
    name: 'tuple',
    regexp: /tuple\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
    transformer: -> (x, y, z, w) { Tuple.new([x.to_f, y.to_f, z.to_f, w.to_f])}
)