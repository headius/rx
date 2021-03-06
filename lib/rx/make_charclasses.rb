#  [4] NameChar ::= Letter | Digit | '.' | '-' | '_' | ':' |
#                  CombiningChar | Extender
#  [5] Name     ::= (Letter | '_' | ':') (NameChar)*
# [84] Letter   ::= BaseChar | Ideographic


require 'set'

def make_char_classes(outdir, support = STDOUT)

  support.puts "  class CharClass"
  support.puts "    POINTS = {}"
  support.puts "    RANGES = {}"

  digit = XMLChars.new(outdir, 'Digit')
  combining = XMLChars.new(outdir, 'CombiningChar')
  extender = XMLChars.new(outdir, 'Extender')
  base = XMLChars.new(outdir, 'BaseChar')
  ideographic = XMLChars.new(outdir, 'Ideographic')

  letter = XMLChars.new outdir
  letter.merge! base
  letter.merge! ideographic

  # NameC
  name_char = XMLChars.new outdir
  # no ':' for namespace reasons
  name_char.points = [ '.'.unpack('U*')[0], '-'.unpack('U*')[0], 
    '_'.unpack('U*')[0] ]
  name_char.merge! letter
  name_char.merge! digit
  name_char.merge! combining
  name_char.merge! extender
  name_char.print('NameChar', support)

  # NameStart
  name_start = XMLChars.new outdir
  name_start.points = [ '_'.unpack('U*')[0] ]
  name_start.merge! letter
  name_start.print('NameStart', support)

  support.print "  end\n\n"
end

class XMLChars
  attr_accessor :points, :ranges

  def initialize(outdir, name = nil)
    @points = []
    @ranges = []

    return unless name
    
    x = File.read("#{outdir}/cc/#{name}")
    x = x.strip.split(/\s*\|\s*/)
    x.each do |cr|
      if cr =~ /^\[.x(....)-.x(....)\]$/
        @ranges << "(0x#{$1}..0x#{$2})"
      elsif cr =~ /^.x(....)$/
        @points << "0x#{$1}"
      else
        print "Bogus datum #{cr}"
      end
    end
  end

  def merge! other
    @points = (Set.new(@points) | Set.new(other.points)).to_a
    @ranges = (Set.new(@ranges) | Set.new(other.ranges)).to_a
  end

  def print(name, out)
    
    @points = @points.map { |a| (a.kind_of? String) ? a : format("0x%04x", a) }.sort
    @ranges = @ranges.sort
    on_line = 0
    out.print "    POINTS['#{name}'] = [\n        "
    @points.each do |p|
      out.print "#{p}, "
      on_line += 1
      if on_line == 8
        out.print "\n        "
        on_line = 0
      end
    end
    out.print "\n      ]\n"
    out.print "    RANGES['#{name}'] = [\n        "
    on_line = 0
    @ranges.each do |r|
      out.print "#{r}, "
      on_line += 1
      if on_line == 4
        out.print "\n        "
        on_line = 0
      end
    end
    out.print "\n    ]\n\n"
  end
end
