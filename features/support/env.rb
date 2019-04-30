require 'rspec/expectations'
require_relative '../../raytracer.rb'

EPSILON = RayTracer::EPSILON

RSpec::Matchers.define :eps do |expected|
  match do |actual|
    case actual
    when Numeric
      (actual - expected).abs < EPSILON

    when Tuple
      data = actual.zip(expected)
      data.all? do |a, e|
        (a - e).abs < EPSILON
      end

    when Matrix
      actual.all_values.zip(expected.all_values).all? do |a, e|
        (a - e).abs < EPSILON
      end
    end
  end
end

module BaseHelper
  def color(r, g, b)
    Tuple.color(r, g, b)
  end

  def expect_tuple_equals(v, w)
    expect(v).to eps(w)
  end

  def p
    @values[:p]
  end

  def put(type, id, value)
    @values ||= {
      a: {},
      v: {},
      p: {},
      c: {},
      m: {}
    }
    @values[type][id] = value
  end

  def get(type, id)
    @values[type][id]
  end
end
