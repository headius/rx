$:.unshift File.join(File.dirname(__FILE__), "..", "src")

require 'rexml/document'
require 'rexml/streamlistener'

class L

  attr_reader @pi_count, @element_count, @the_count, @para_count, @jpg_count
  
  def initialize
    @pi_count = 0
    @element_count = 0
    @the_count = 0
    @para_count = 0
    @jpg_count = 0
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
    @element_count += 1
    if name == 'p'
      @para_count += 1
    end
    if name == 'img' && attrs['src'] =~ /\.jpg$/
      @jpg_count += 1
    end
  end

  def text(text)
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

