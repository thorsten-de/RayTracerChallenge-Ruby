FMAP = lambda { |name|
  case name
  when '√'
    ->(x) { Math.sqrt(x) }
  else
    ->(x) { x }
  end
}

FRACT = lambda { |sign, fun, nom, fraction, den|
  nominator = (nom + fraction).to_f
  # p(sign: sign, fun: fun, nom: nom, fraction: fraction, den: den)

  frac = FMAP.call(fun).call(nominator)
  frac /= den[1..-1].to_f if den != ''
  frac * (sign == '-' ? -1 : 1)
}

ParameterType(
  name: 'num',
  regexp: /-?\d+\.?\d*/,
  transformer: ->(num) { num.to_f }
)

# ParameterType(
#  name: 'vector',
#  regexp: /vector\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
#  transformer: ->(x, y, z) { Tuple.vector(x.to_f, y.to_f, z.to_f) }
# )

# ParameterType(
#  name: 'point',
#  regexp: /point\((-?\d+\.?\d*), (-?\d+\.?\d*), (-?\d+\.?\d*)\)/,
#  transformer: ->(x, y, z) { Tuple.point(x.to_f, y.to_f, z.to_f) }
# )

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
  regexp: %r{(-?)(√)(\d+)((\.\d+)?)((/\d)?)},
  transformer: FRACT
)

ParameterType(
  name: 'bool',
  regexp: /(false|False|true|True)/,
  transformer: ->(bool_str) { bool_str.casecmp('false').zero? ? false : true }
)

ParameterType(
  name: 'vector',
  regexp: %r{vector\((-?)(√?)(\d+)((\.\d+)?)((/\d)?), (-?)(√?)(\d+)((\.\d+)?)((/\d)?), (-?)(√?)(\d+)((\.\d+)?)((/\d)?)\)},
  transformer: lambda { |x_sign, x_fun, x_nom, x_fraction, x_den, y_sign, y_fun, y_nom, y_fraction, y_den, z_sign, z_fun, z_nom, z_fraction, z_den|
                 Tuple.vector(
                   FRACT.call(x_sign, x_fun, x_nom, x_fraction, x_den),
                   FRACT.call(y_sign, y_fun, y_nom, y_fraction, y_den),
                   FRACT.call(z_sign, z_fun, z_nom, z_fraction, z_den)
                 )
               }
)

ParameterType(
  name: 'point',
  regexp: %r{point\((-?)(√?)(\d+)((\.\d+)?)((/\d)?), (-?)(√?)(\d+)((\.\d+)?)((/\d)?), (-?)(√?)(\d+)((\.\d+)?)((/\d)?)\)},
  transformer: lambda { |x_sign, x_fun, x_nom, x_fraction, x_den, y_sign, y_fun, y_nom, y_fraction, y_den, z_sign, z_fun, z_nom, z_fraction, z_den|
                 Tuple.point(
                   FRACT.call(x_sign, x_fun, x_nom, x_fraction, x_den),
                   FRACT.call(y_sign, y_fun, y_nom, y_fraction, y_den),
                   FRACT.call(z_sign, z_fun, z_nom, z_fraction, z_den)
                 )
               }
)
