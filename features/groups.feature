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