$:.unshift File.join(File.dirname(__FILE__), "..", "src")

require 'benchmark'
require 'rexml/document'
require 'reader'
require 'rexml'

class L

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
    #if @title
    #  puts "T: #{text}" 
    #  @title = false
    #end 
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

(ARGV[0] || 5).to_i.times do
  Benchmark.bm(20) do |bm|
    bm.report 'REXML' do
      p_1 = L.new
      f = 'test/o-0678.xml'
      parser = nil
      File.open(f) do |file|
        REXML::Document.parse_stream(file, p_1)
      end
    end
    
    bm.report 'RX' do
      p_1 = L.new
      f = 'test/o-0678.xml'
      parser = nil
      File.open(f) do |file|
        parser = RX::Reader.new(file, RX::RXToStreamListener.new(p_1))
        parser.go
      end
    end
  end
end

