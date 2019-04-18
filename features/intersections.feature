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