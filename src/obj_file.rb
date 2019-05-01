class ObjFile
  attr_reader :ignored_lines, :vertices

  PARSERS = [
    { pattern: /^v\s+([-\d\.]+)\s+([-\d\.]+)\s+([-\d\.]+)$/, f: lambda { |data, match|
                                                                  data[:vertices] << Tuple.point(match[1].to_f, match[2].to_f, match[3].to_f)
                                                                  data
                                                                } },
    { pattern: /.*/, f: ->(data, _match) { data[:ignored] += 1; data } }
  ].freeze

  def self.parse(content)
    parser = ObjFile.new
    parser.parse(content)
    parser
  end

  def parse(content)
    lines = content.readlines
    result = lines.reduce(ignored: 0, vertices: [nil]) do |acc, line|
      PARSERS.reduce(acc) do |data, parser|
        parser[:pattern].match(line) do |m|
          parser[:f].call(data, m)
        end || data
      end
    end

    @ignored_lines = result[:ignored]
    @vertices = result[:vertices]
  end
end
