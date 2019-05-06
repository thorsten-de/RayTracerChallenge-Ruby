Feature: Intersections

  Scenario: An intersection encapsulates t and object
    Given s ← sphere
    When i ← intersection(3.5, s)
    Then i.t = 3.5
    And i.object = s

  Scenario: Precomputing the state of an intersection
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← sphere
    And i ← intersection(4, s)
    When comps ← prepare_computations(i, r)
    Then comps.t = i.t
    And comps.object = i.object
    And comps.point = point(0, 0, -1)
    And comps.eyev = vector(0, 0, -1)
    And comps.normalv = vector(0, 0, -1)

  Scenario: The hit, when an intersection occurs on the outside
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← sphere
    And i ← intersection(4, s)
    When comps ← prepare_computations(i, r)
    Then comps.inside = false

  Scenario: The hit, when an intersection occurs on the inside
    Given r ← ray(point(0, 0, 0), vector(0, 0, 1))
    And s ← sphere
    And i ← intersection(1, s)
    When comps ← prepare_computations(i, r)
    Then comps.point = point(0, 0, 1)
    And comps.eyev = vector(0, 0, -1)
    And comps.inside = true
    # normal would have been (0, 0, 1), but is inverted!
    And comps.normalv = vector(0, 0, -1)

  Scenario: The hit should offset the point
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s1 ← sphere with:
      | transform | translation(0, 0, 1) |
    And i ← intersection(5, s1)
    When comps ← prepare_computations(i, r)
    Then comps.over_point.z < -EPSILON/2
    And comps.point.z > comps.over_point.z

  Scenario: Precomputing the reflection vector
    Given shape ← plane
    And v ← vector(0, -√2/2, √2/2)
    And r ← ray(point(0, 1, -1), v)
    And i ← intersection(√2, shape)
    When comps ← prepare_computations(i, r)
    Then comps.reflectv = vector(0, √2/2, √2/2)

  Scenario: The under point is offset below the surface
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s1 ← sphere with:
      | transform | translation(0, 0, 1) |
    And i ← intersection(5, s1)
    And xs ← intersections(i)
    When comps ← prepare_computations(i, r, xs)
    Then comps.under_point.z > EPSILON/2
    And comps.point.z < comps.under_point.z

  Scenario: The Schlick approximation under total internal reflection
    Given shape ← glass_sphere
    And r ← ray(point(0, 0, √2/2), vector(0, 1, 0))
    And xs ← intersections(-√2/2:shape, √2/2:shape)
    When comps ← prepare_computations(xs[1], r, xs)
    And reflectance ← schlick(comps)
    Then reflectance = 1.0

  Scenario: The Schlick approximation with a perpendicular viewing angle
    Given shape ← glass_sphere
    And r ← ray(point(0, 0, 0), vector(0, 1, 0))
    And xs ← intersections(-1:shape, 1:shape)
    When comps ← prepare_computations(xs[1], r, xs)
    And reflectance ← schlick(comps)
    Then reflectance = 0.04

  Scenario: The Schlick approximation with small angle and n2 > n1
    Given shape ← glass_sphere
    And r ← ray(point(0, 0.99, -2), vector(0, 0, 1))
    And xs ← intersections(1.8589:shape)
    When comps ← prepare_computations(xs[0], r, xs)
    And reflectance ← schlick(comps)
    Then reflectance = 0.48873

  Scenario: An intersection can encapsulate `u` and `v`
    Given s ← triangle(point(0, 1, 0), point(-1, 0, 0), point(1, 0, 0))
    When i ← intersection_with_uv(3.5, s, 0.2, 0.4)
    Then i.u = 0.2
    And i.v = 0.4