Feature: Groups

  Groups combine Shapes

  Scenario: Creating a new group
    Given g ← group
    Then g.transform = identity_matrix
    And g is empty

  Scenario: Adding a child to a group
    Given g ← group
    And s ← test_shape
    When add_child(g, s)
    Then g is not empty
    And g includes s
    And s.parent = g

  Scenario: Intersecting a ray with an empty group
    Given g ← group
    And r ← ray(point(0, 0, 0), vector(0, 0, 1))
    When xs ← local_intersect(g, r)
    Then xs is empty

  Scenario: Intersecting a ray with a nonempty group
    Given g ← group
    And s1 ← sphere
    And s2 ← sphere
    And M1 ← translation(0, 0, -3)
    And set_transform(s2, M1)
    And s3 ← sphere
    And M2 ← translation(5, 0, 0)
    And set_transform(s3, M2)
    And add_child(g, s1)
    And add_child(g, s2)
    And add_child(g, s3)
    When r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And xs ← local_intersect(g, r)
    Then xs.count = 4
    And xs[0].object = s2
    And xs[1].object = s2
    And xs[2].object = s1
    And xs[3].object = s1

  Scenario: Intersecting a transformed group
    Given g ← group
    And M1 ← scaling(2, 2, 2)
    And set_transform(g, M1)
    And s1 ← sphere
    And M2 ← translation(5, 0, 0)
    And set_transform(s1, M2)
    And add_child(g, s1)
    When r ← ray(point(10, 0, -10), vector(0, 0, 1))
    And xs ← intersect(g, r)
    Then xs.count = 2


  Scenario: Converting a point from world to object space
    Given g1 ← group
    And M1 ← rotation('y', π/2)
    And set_transform(g1, M1)
    And g2 ← group
    And M2 ← scaling(2, 2, 2)
    And set_transform(g2, M2)
    And add_child(g1, g2)
    And s ← sphere
    And M3 ← translation(5, 0, 0)
    And set_transform(s, M3)
    And add_child(g2, s)
    When p ← world_to_object(s, point(-2, 0, -10))
    Then p = point(0, 0, -1)

  Scenario: Converting a normal from object to world space
    Given g1 ← group
    And M1 ← rotation('y', π/2)
    And set_transform(g1, M1)
    And g2 ← group
    And M2 ← scaling(1, 2, 3)
    And set_transform(g2, M2)
    And add_child(g1, g2)
    And s ← sphere
    And M3 ← translation(5, 0, 0)
    And set_transform(s, M3)
    And add_child(g2, s)
    When n ← normal_to_world(s, vector(√3/3, √3/3, √3/3))
    Then n = vector(0.2857, 0.4286, -0.8571)

  Scenario: Converting a normal from object to world space
    Given g1 ← group
    And M1 ← rotation('y', π/2)
    And set_transform(g1, M1)
    And g2 ← group
    And M2 ← scaling(1, 2, 3)
    And set_transform(g2, M2)
    And add_child(g1, g2)
    And s ← sphere
    And M3 ← translation(5, 0, 0)
    And set_transform(s, M3)
    And add_child(g2, s)
    When n ← normal_at(s, point(1.7321, 1.1547, -5.5774))
    Then n = vector(0.2857, 0.4286, -0.8571)

  Scenario: Calculate bounds of simple group without transformations
    Given g ← group
    And s ← test_shape
    When add_child(g, s)
    Then g.bounds = s.bounds

  Scenario: Calculate bounds of group multiple objects
    Given g ← group
    And s ← test_shape
    And s1 ← test_shape
    And M1 ← translation(-1, -2, -3)
    And set_transform(s1, M1)
    And s2 ← test_shape
    And M2 ← translation(1, 2, 3)
    And set_transform(s2, M2)
    When add_child(g, s)
    When add_child(g, s1)
    When add_child(g, s2)
    Then g.bounds = [point(-2, -3, -4), point(2, 3, 4)]

  Scenario: Calculate bounds axis-aligned with rotations
    Given g ← group
    And s ← test_shape
    And M1 ← rotation('x', π/4)
    And set_transform(s, M1)
    When add_child(g, s)
    Then g.bounds = [point(-1, -√2, -√2), point(1, √2, √2)]

  Scenario: Calculate intersection with local bounds when ray hits
    Given g ← group
    And s ← test_shape
    And M1 ← rotation('x', π/4)
    And set_transform(s, M1)
    When add_child(g, s)
    When r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And xs ← local_intersect_bounds(g, r)
    Then xs.count = 2
    And xs[0].t = -√2 + 5
    And xs[1].t = √2 + 5


  Scenario: Calculate intersection when ray misses group bounds
    Given g ← group
    And s ← test_shape
    And M1 ← rotation('x', π/4)
    And set_transform(s, M1)
    When add_child(g, s)
    When r ← ray(point(0, 2, -5), vector(0, 0, 1))
    And xs ← local_intersect_bounds(g, r)
    Then xs.count = 0
    And g.hit_bounds(r) = false



  Scenario: Calculate intersection when ray hits  group of multiple objects
    Given g ← group
    And s ← sphere
    And s1 ← sphere
    And M1 ← translation(-2, -2, -2)
    And set_transform(s1, M1)
    And s2 ← sphere
    And M2 ← translation(2, 2, 2)
    And set_transform(s2, M2)
    When add_child(g, s)
    When add_child(g, s1)
    When add_child(g, s2)
    When r ← ray(point(0, 0, -5), vector(0, 0, 1))
    And xs ← intersect(g, r)
    Then xs.count = 2
    And xs[0].t = 4
    And xs[1].t = 6
    And g.hit_bounds(r) = true

  Scenario: Calculate intersection when ray misses group of multiple objects
    Given g ← group
    And s0 ← shape
    And s1 ← shape
    And M1 ← translation(-2, -2, -2)
    And set_transform(s1, M1)
    And s2 ← shape
    And M2 ← translation(2, 2, 2)
    And set_transform(s2, M2)
    When add_child(g, s0)
    When add_child(g, s1)
    When add_child(g, s2)
    When r ← ray(point(0, -4, -5), vector(0, 0, 1))
    Then g.hit_bounds(r) = false
    And children intersections are not tested