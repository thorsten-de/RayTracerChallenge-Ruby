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