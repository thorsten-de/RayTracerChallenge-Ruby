Feature: Patterns

  Background:
    Given black ← color(0, 0, 0)
    And white ← color(1, 1, 1)


  Scenario: A stripe pattern is constant in y
    Given pattern ← stripe_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(0, 1, 0)) = white
    And pattern_at(pattern, point(0, 2, 0)) = white

  Scenario: A stripe pattern is constant in z
    Given pattern ← stripe_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(0, 0, 1)) = white
    And pattern_at(pattern, point(0, 0, 2)) = white

  Scenario: A stripe pattern alternates in x
    Given pattern ← stripe_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(0.9, 0, 0)) = white
    And pattern_at(pattern, point(1, 0, 0)) = black
    And pattern_at(pattern, point(-0.1, 0, 0)) = black
    And pattern_at(pattern, point(-1, 0, 0)) = black
    And pattern_at(pattern, point(-1.1, 0, 0)) = white

  Scenario: Stripes with an object transformation
    Given s ← sphere
    And m ← scaling(2, 2, 2)
    And set_transform(s, m)
    And pattern ← test_pattern
    When c ← pattern_at_shape(pattern, s, point(2, 3, 4))
    Then c = color(1, 1.5, 2)
  Scenario: Stripes with a pattern transformation
    Given s ← sphere
    And pattern ← test_pattern
    And M1 ← scaling(2, 2, 2)
    And set_pattern_transform(pattern, M1)
    When c ← pattern_at_shape(pattern, s, point(2, 3, 4))
    Then c = color(1, 1.5, 2)

  Scenario: Stripes with both an object and a pattern transformation
    Given s ← sphere
    And m ← scaling(2, 2, 2)
    And set_transform(s, m)
    And pattern ← test_pattern
    And M2 ← translation(0.5, 1, 1.5)
    And set_pattern_transform(pattern, M2)
    When c ← pattern_at_shape(pattern, s, point(2.5, 3, 3.5))
    Then c = color(0.75, 0.5, 0.25)


  Scenario: The default pattern transformation
    Given pattern ← test_pattern
    Then pattern.transform = identity_matrix

  Scenario: Assigning a transformation
    Given pattern ← test_pattern
    And M1 ← translation(1, 2, 3)
    When set_pattern_transform(pattern, M1)
    Then pattern.transform = M1

  Scenario: A gradient linearly interpolates between colors
    Given pattern ← gradient_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(0.25, 0, 0)) = color(0.75, 0.75, 0.75)
    And pattern_at(pattern, point(0.5, 0, 0)) = color(0.5, 0.5, 0.5)
    And pattern_at(pattern, point(0.75, 0, 0)) = color(0.25, 0.25, 0.25)

  Scenario: A ring should extend in both x and z
    Given pattern ← ring_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(1, 0, 0)) = black
    And pattern_at(pattern, point(0, 0, 1)) = black
    # 0.708 = just slightly more than √ 2/2
    And pattern_at(pattern, point(0.708, 0, 0.708)) = black

  Scenario: Checkers should repeat in x
    Given pattern ← checkers_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(0.99, 0, 0)) = white
    And pattern_at(pattern, point(1.01, 0, 0)) = black

  Scenario: Checkers should repeat in y
    Given pattern ← checkers_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(0, 0.99, 0)) = white
    And pattern_at(pattern, point(0, 1.01, 0)) = black

  Scenario: Checkers should repeat in z
    Given pattern ← checkers_pattern(white, black)
    Then pattern_at(pattern, point(0, 0, 0)) = white
    And pattern_at(pattern, point(0, 0, 0.99)) = white
    And pattern_at(pattern, point(0, 0, 1.01)) = black