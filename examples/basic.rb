require 'rx'
require 'rx/rexml'

# A basic example of REXML listener parsing using RX
class Listener
  def doctype(name, pub_sys, long_name, uri)
    puts "doctype: #{name}"
  end

  def cdata(x)
    puts "CDATA: #{x}"
  end
  def comment(x)
    puts "comment: #{x}"
  end

  def instruction(name, instruction)
    puts "instruction: #{name} #{instruction}"
  end

  def tag_start(name, attrs)
    puts "tag start: #{name} #{attrs}"
  end

  def tag_end(name)
    puts "tag end: #{name}"
  end

  def text(text)
    puts "text: #{text}"
  end
end

File.open(ARGV[0] || fail('specify file')) do |file|
  reader = RX::Reader.new(file, RX::RXToStreamListener.new(Listener.new))
  reader.go
end