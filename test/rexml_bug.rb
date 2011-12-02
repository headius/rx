$:.unshift File.join(File.dirname(__FILE__), "..", "src")

require 'test/unit'
require 'rexml/document'

class TestInput < Test::Unit::TestCase

  def test_xbd
    api = API.new
    f = 'test/xbd.xml'
    begin
      REXML::Document.parse_stream(File.new(f), api)
    rescue Exception
      assert(false, "Parse_stream blew up: #{$!.class}")
    end
  end
  
  def test_cdata
    api = API.new
    f = 'test/doctype.xml'
    begin
      REXML::Document.new(File.new(f))
    rescue Exception
      assert(false, "Document.new blew up: #{$!.class}")
    end

  end
  
end

class API

  attr_reader :pi_count, :element_count, :the_count, :para_count, :jpg_count
  attr_accessor :debug
  
  def to_s
    "PIs: #{@pi_count}, Els: #{@element_count}, Ps: #{@para_count}, JPGs: #{@jpg_count}, Thes: #{@the_count}"
  end
  
  def initialize
    @pi_count = 0
    @element_count = 0
    @the_count = 0
    @para_count = 0
    @jpg_count = 0
    @title = false #debug shit
    @debug = false

  end

  def doctype(name, pub_sys, long_name, uri)
  end

  def cdata(x)
  end
  def comment(x)
  end

  def instruction(name, instruction)
    @pi_count += 1
  end

  def tag_end(name)
  end

  def tag_start(name, attrs)
    @title = true if name == 'title'
    @element_count += 1
    if name == 'p'
      @para_count += 1
    end
    if name == 'img' && attrs['src'] =~ /\.jpg$/
      @jpg_count += 1
    end
  end

  def text(text)
    # puts "T #{text}" unless text =~ /^\s*$/
    text.scan(/\Wthe\W/) { @the_count += 1 }
  end

  def report
    puts "PIs        #{@pi_count}"
    puts "Elements   #{@element_count}"
    puts "Paragraphs #{@para_count}"
    puts "Jpegs      #{@jpg_count}"
    puts "'the'      #{@the_count}"
  end

end


