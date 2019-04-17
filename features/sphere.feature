Feature: Sphere rendering

  Scenario: The normal on a sphere at a point on the x axis
    Given s ← sphere
    When n ← normal_at(s, point(1, 0, 0))
    Then n = vector(1, 0, 0)

  Scenario: The normal on a sphere at a point on the y axis
    Given s ← sphere
    When n ← normal_at(s, point(0, 1, 0))
    Then n = vector(0, 1, 0)

  Scenario: The normal on a sphere at a point on the z axis
    Given s ← sphere
    When n ← normal_at(s, point(0, 0, 1))
    Then n = vector(0, 0, 1)

  Scenario: The normal on a sphere at a nonaxial point
    Given s ← sphere
    And p ← point(√3/3, √3/3, √3/3)
    When n ← normal_at(s, p)
    Then n = vector(√3/3, √3/3, √3/3)

  Scenario: The normal is a normalized vector
    Given s ← sphere
    And p ← point(√3/3, √3/3, √3/3)
    When n ← normal_at(s, p)
    Then n = normalize(n)

  Scenario: Computing the normal on a translated sphere
    Given s ← sphere
    And m ← translation(0, 1, 0)
    And set_transform(s, m)
    When n ← normal_at(s, point(0, 1.70711, -0.70711))
    Then n = vector(0, 0.70711, -0.70711)

  Scenario: Computing the normal on a transformed sphere
    Given s ← sphere
    And M1 ← scaling(1, 0.5, 1)
    And M2 ← rotation("z", π / 5)
    And m ← M1 * M2
    And set_transform(s, m)
    And p ← point(√0/1, √2/2, -√2/2)
    When n ← normal_at(s, p)
    Then n = vector(0, 0.97014, -0.24254)


  Scenario: Reflecting a vector approaching at 45°
    Given v ← vector(1, -1, 0)
    And n ← vector(0, 1, 0)
    When r ← reflect(v, n)
    Then r = vector(1, 1, 0)

  Scenario: Reflecting a vector off a slanted surface
    Given v ← vector(0, -1, 0)
    And n ← vector(√2/2, √2/2, 0)
    When r ← reflect(v, n)
    Then r = vector(1, 0, 0)

  Scenario: A sphere has a default material
    Given s ← sphere
    When m ← s.material
    Then m = material

  Scenario: A sphere may be assigned a material
    Given s ← sphere
    And m ← material
    And m.ambient ← 1
    When s.material ← m
    Then s.material = m

