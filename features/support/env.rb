require 'rspec/expectations'

EPSILON = 0.0001
  

RSpec::Matchers.define :eps do |expected|
  match do |actual|
    (actual - expected).abs < EPSILON
  end
end

module BaseHelper

  def color(r, g, b)
    Tuple::color(r, g, b)
  end

  def expect_tuple_equals(v, w)
    v.zip(w)
      .map do |v_i, w_i|
        expect(v_i).to eps(w_i)
      end 
  end

  def put(type, id, value)
    @values ||= {
      a: {},
      v: {},
      p: {},
      c: {},
      m: {},
    }
    @values[type][id] = value
  end

  def get(type, id)
    @values[type][id]
  end
end