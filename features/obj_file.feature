Feature: OBJ File Parser

  Scenario: Ignoring unrecognized lines
    Given gibberish ← a file containing:
      """
      There was a young lady named Bright
      who traveled much faster than light.
      She set out one day
      in a relative way,
      and came back the previous night.
      """
    When parser ← parse_obj_file(gibberish)
    Then parser should have ignored 5 lines

  Scenario: Vertex records
    Given file ← a file containing:
      """
      v -1 1 0
      v -1.0000 0.5000 0.0000
      v 1 0 0
      v 1 1 0
      """
    When parser ← parse_obj_file(file)
    Then parser.vertices[1] = point(-1, 1, 0)
    And parser.vertices[2] = point(-1, 0.5, 0)
    And parser.vertices[3] = point(1, 0, 0)
    And parser.vertices[4] = point(1, 1, 0)