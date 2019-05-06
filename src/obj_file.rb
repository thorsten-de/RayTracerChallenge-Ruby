class ObjFile
  attr_accessor :ignored_lines,
                :vertices,
                :normals,
                :default_group,
                :current_group,
                :groups

  PARSERS = [
    { pattern: /^v\s+([-\d\.]+)\s+([-\d\.]+)\s+([-\d\.]+)/, f: lambda { |data, match|
                                                                 data.vertices << Tuple.point(match[1].to_f, match[2].to_f, match[3].to_f)
                                                                 data
                                                               } },
    { pattern: /^vn\s+([-\d\.]+)\s+([-\d\.]+)\s+([-\d\.]+)/, f: lambda { |data, match|
                                                                  data.normals << Tuple.vector(match[1].to_f, match[2].to_f, match[3].to_f)
                                                                  data
                                                                } },
    { pattern: /^f\s+(.*)$/, f: lambda { |data, match|
                                  vertex_indices = match[1].split
                                                           .map { |token| data.create_vertex(token) }
                                  shapes = data.create_shape(vertex_indices)
                                  data.add_to_group(shapes)
                                  data
                                } },
    { pattern: /^g\s+(.*)$/, f: lambda { |data, match|
                                  name = match[1]
                                  data.groups[name] = data.current_group = Group.new
                                  data
                                } },
    { pattern: /.*/, f: ->(data, _match) { data.ignored_lines += 1; data } }
  ].freeze

  def initialize(_opts = {})
    @ignored_lines = 0
    @vertices = [nil]
    @normals = [nil]
    @shapes = []
    @default_group = Group.new
    @current_group = @default_group
    @groups = { 'Default Group' => @default_group }
  end

  def self.parse(content)
    parser = ObjFile.new
    parser.parse(content)
    parser
  end

  def self.from_file(filename)
    parser = parse(File.open(filename))
    parser.obj_to_group
  end

  def parse(content)
    content.readlines
           .reduce(self) do |acc, line|
      PARSERS.reduce(acc) do |data, parser|
        parser[:pattern].match(line) do |m|
          parser[:f].call(data, m)
        end || data
      end
    end
  end

  def obj_to_group
    Group.new(children: @groups.values)
  end

  def create_shape(vertex_indices)
    f = if vertex_indices.any? { |vi| vi.length == 1 }
          lambda { |indices|
            Triangle.new(indices.map { |i| @vertices[i[0]] })
          }
        else
          lambda { |indices|
            vertex, _texture, normal = indices.transpose
            SmoothTriangle.new(vertex.map { |i| @vertices[i] },
                               normals: normal.map { |i| @normals[i] })
          }
        end
    fan_triangulation(vertex_indices, f)
  end

  def add_to_group(shapes, group = @current_group)
    shapes.reduce(group, &:<<)
  end

  def fan_triangulation(vertices, f)
    (1..(vertices.length - 2)).map do |i|
      f.call([vertices[0], vertices[i], vertices[i + 1]])
    end
  end

  def create_vertex(token)
    token.split('/')
         .map(&:to_i)
  end
end
