Feature: Casting Rays to the Universe

  Scenario: Creating and querying a ray
    Given p ← point(1, 2, 3)
    And v ← vector(4, 5, 6)
    When r ← ray(p, v)
    Then r.origin = origin
    And r.direction = direction

  Scenario: Computing a point from a distance
    Given p ← point(2, 3, 4)
    And v ← vector(1, 0, 0)
    When r ← ray(p, v)
    Then position(r, 0.0) = point(2.0, 3, 4)
    And position(r, 1.0) = point(3.0, 3, 4)
    And position(r, -1.0) = point(1.0, 3, 4)
    And position(r, 2.5) = point(4.5, 3, 4)

  Scenario: Computing a point from a distance
    Given r ← ray(point(2, 3, 4), vector(1, 0, 0))
    Then position(r, 0) = point(2, 3, 4)
    And position(r, 1) = point(3, 3, 4)
    And position(r, -1) = point(1, 3, 4)
    And position(r, 2.5) = point(4.5, 3, 4)

  Scenario: A ray intersects a sphere at two points
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← sphere
    When xs ← intersect(s, r)
    Then xs.count = 2
    And xs[0].t = 4.0
    And xs[1].t = 6.0

  Scenario: A ray intersects a sphere at a tangent
    Given r ← ray(point(0, 1, -5), vector(0, 0, 1))
    And s ← sphere
    When xs ← intersect(s, r)
    Then xs.count = 2
    And xs[0].t = 5.0
    And xs[1].t = 5.0

  Scenario: A ray misses a sphere
    Given r ← ray(point(0, 2, -5), vector(0, 0, 1))
    And s ← sphere
    When xs ← intersect(s, r)
    Then xs.count = 0

  Scenario: A ray originates inside a sphere
    Given r ← ray(point(0, 0, 0), vector(0, 0, 1))
    And s ← sphere
    When xs ← intersect(s, r)
    Then xs.count = 2
    And xs[0].t = -1.0
    And xs[1].t = 1.0


  Scenario: A sphere is behind a ray
    Given r ← ray(point(0, 0, 5), vector(0, 0, 1))
    And s ← sphere
    When xs ← intersect(s, r)
    Then xs.count = 2
    And xs[0].t = -6.0
    And xs[1].t = -4.0

  Scenario: An intersection encapsulates t and object
    Given s ← sphere
    When i ← intersection(3.5, s)
    Then i.t = 3.5
    And i.object = s

  Scenario: Aggregating intersections
    Given s ← sphere
    And i1 ← intersection(1, s)
    And i2 ← intersection(2, s)
    When xs ← intersections(i1, i2)
    Then xs.count = 2
    And xs[0].t = 1
    And xs[1].t = 2

  Scenario: Intersect sets the object on the intersection
    Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And s ← sphere
    When xs ← intersect(s, r)
    Then xs.count = 2
    And xs[0].object = s
    And xs[1].object = s

  Scenario: The hit, when all intersections have positive t
    Given s ← sphere
    And i1 ← intersection(1, s)
    And i2 ← intersection(2, s)
    And xs ← intersections(i2, i1)
    When i ← hit(xs)
    Then i = i1
  Scenario: The hit, when some intersections have negative t
    Given s ← sphere
    And i1 ← intersection(-1, s)
    And i2 ← intersection(1, s)
    And xs ← intersections(i2, i1)
    When i ← hit(xs)
    Then i = i2
  Scenario: The hit, when all intersections have negative t
    Given s ← sphere
    And i1 ← intersection(-2, s)
    And i2 ← intersection(-1, s)
    And xs ← intersections(i2, i1)
    When i ← hit(xs)
    Then i is nothing

  Scenario: The hit is always the lowest nonnegative intersection
    Given s ← sphere
    And i1 ← intersection(5, s)
    And i2 ← intersection(7, s)
    And i3 ← intersection(-3, s)
    And i4 ← intersection(2, s)
    And xs ← intersections(i1, i2, i3, i4)
    When i ← hit(xs)
    Then i = i4

  Scenario: Translating a ray
    Given r ← ray(point(1, 2, 3), vector(0, 1, 0))
    And m ← translation(3, 4, 5)
    When r2 ← transform(r, m)
    Then r2.origin = point(4, 6, 8)
    And r2.direction = vector(0, 1, 0)
  Scenario: Scaling a ray
    Given r ← ray(point(1, 2, 3), vector(0, 1, 0))
    And m ← scaling(2, 3, 4)
    When r2 ← transform(r, m)
    Then r2.origin = point(2, 6, 12)
    And r2.direction = vector(0, 3, 0)