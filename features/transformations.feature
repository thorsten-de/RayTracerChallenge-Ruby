Feature: Transformations

  Scenario: Multiplying by a translation matrix
    Given transform ← translation(5, -3, 2)
    And p ← point(-3, 4, 5)
    Then transform * p = point(2, 1, 7)

  Scenario: Multiplying by the inverse of a translation matrix
    Given transform ← translation(5, -3, 2)
    And inv ← inverse(transform)
    And p ← point(-3, 4, 5)
    Then inv * p = point(-8, 7, 3)

  Scenario: Translation does not affect vectors
    Given transform ← translation(5, -3, 2)
    And v ← vector(-3, 4, 5)
    Then transform * v = v

  Scenario: A scaling matrix applied to a point
    Given transform ← scaling(2, 3, 4)
    And p ← point(-4, 6, 8)
    Then transform * p = point(-8, 18, 32)

  Scenario: A scaling matrix applied to a vector
    Given transform ← scaling(2, 3, 4)
    And v ← vector(-4, 6, 8)
    Then transform * v = vector(-8, 18, 32)

  Scenario: Multiplying by the inverse of a scaling matrix
    Given transform ← scaling(2, 3, 4)
    And inv ← inverse(transform)
    And v ← vector(-4, 6, 8)
    Then inv * v = vector(-2, 2, 2)

  Scenario: Reflection is scaling by a negative value
    Given transform ← scaling(-1, 1, 1)
    And p ← point(2, 3, 4)
    Then transform * p = point(-2, 3, 4)

  Scenario: Rotating a point around the x axis
    Given p ← point(0, 1, 0)
    And half_quarter ← rotation("x", π / 4)
    And full_quarter ← rotation("x", π / 2)
    Then half_quarter * p = point("0", "√2/2", "√2/2")
    And full_quarter * p = point(0, 0, 1)

  Scenario: The inverse of an x-rotation rotates in the opposite direction
    Given p ← point(0, 1, 0)
    And half_quarter ← rotation("x", π / 4)
    And inv ← inverse(half_quarter)
    Then inv * p = point("0", "√2/2", "-√2/2")

  Scenario: Rotating a point around the y axis
    Given p ← point(0, 0, 1)
    And half_quarter ← rotation("y", π / 4)
    And full_quarter ← rotation("y", π / 2)
    Then half_quarter * p = point("√2/2", "0", "√2/2")
    And full_quarter * p = point(1, 0, 0)

  Scenario: Rotating a point around the z axis
    Given p ← point(0, 1, 0)
    And half_quarter ← rotation("z", π / 4)
    And full_quarter ← rotation("z", π / 2)
    Then half_quarter * p = point("-√2/2", "√2/2", "0")
    And full_quarter * p = point(-1, 0, 0)

  Scenario: A shearing transformation moves x in proportion to y
    Given transform ← shearing(1, 0, 0, 0, 0, 0)
    And p ← point(2, 3, 4)
    Then transform * p = point(5, 3, 4)

  Scenario: A shearing transformation moves z in proportion to y
    Given transform ← shearing(0, 0, 0, 0, 0, 1)
    And p ← point(2, 3, 4)
    Then transform * p = point(2, 3, 7)

  Scenario: Individual transformations are applied in sequence
    Given p1 ← point(1, 0, 1)
    And M1 ← rotation("x", π / 2)
    And M2 ← scaling(5, 5, 5)
    And M3 ← translation(10, 5, 7)
    # apply rotation first
    When p2 ← M1 * p1
    Then p2 = point(1, -1, 0)
    # then apply scaling
    When p3 ← M2 * p2
    Then p3 = point(5, -5, 0)
    # then apply translation
    When p4 ← M3 * p3
    Then p4 = point(15, 0, 7)

  Scenario: Chained transformations must be applied in reverse order
    Given p ← point(1, 0, 1)
    And M1 ← rotation("x", π / 2)
    And M2 ← scaling(5, 5, 5)
    And M3 ← translation(10, 5, 7)
    When T ← M3 * M2 * M1
    Then T * p = point(15, 0, 7)