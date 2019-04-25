Feature: Shape

  Scenario: The default transformation
    Given s ← test_shape
    Then s.transform = identity_matrix

  Scenario: Assigning a transformation
    Given s ← test_shape
    And m ← translation(2, 3, 4)
    And set_transform(s, m)
    Then s.transform = translation(2, 3, 4)

  Scenario: The default material
    Given s ← test_shape
    When m ← s.material
    Then m = material

  Scenario: Assigning a material
    Given s ← test_shape
    And m ← material
    And m.ambient ← 1
    When s.material ← m
    Then s.material = m

  Scenario: Intersecting a scaled shape with a ray
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← test_shape
    And m ← scaling(2, 2, 2)
    When set_transform(s, m)
    And xs ← intersect(s, r)
    Then s.saved_ray.origin = point(0, 0, -2.5)
    And s.saved_ray.direction = vector(0, 0, 0.5)

  Scenario: Intersecting a translated shape with a ray
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← test_shape
    And m ← translation(5, 0, 0)
    When set_transform(s, m)
    And xs ← intersect(s, r)
    Then s.saved_ray.origin = point(-5, 0, -5)
    And s.saved_ray.direction = vector(0, 0, 1)

  Scenario: Computing the normal on a translated shape
    Given s ← test_shape
    And m ← translation(0, 1, 0)
    When set_transform(s, m)
    And n ← normal_at(s, point(0, 1.70711, -0.70711))
    Then n = vector(0, 0.70711, -0.70711)

  Scenario: Computing the normal on a transformed shape
    Given s ← test_shape
    And M1 ← scaling(1, 0.5, 1)
    And M2 ← rotation("z", π / 5)
    And m ← M1 * M2
    And set_transform(s, m)
    And p ← point(√0/1, √2/2, -√2/2)
    When n ← normal_at(s, p)
    Then n = vector(0, 0.97014, -0.24254)

  Scenario: A shape has a parent attribute
    Given s ← test_shape
    Then s.parent is nothing