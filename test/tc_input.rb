$:.unshift File.join(File.dirname(__FILE__), "..", "src")

require 'test/unit'
require 'input.rb'

class Dummy1
  def initialize
    @a = '<x/>'
    @i = 0
  end
  def next_byte
    r = @a[@i]
    @i += 1
    r
  end
  def read_some
    s = @a[@i .. -1]
    @i = @a.length
    s
  end
end

class Dummy2
end

class TestInput < Test::Unit::TestCase

  def setup
    @base = File.dirname(__FILE__) + '/..'
  end

  def test_new
    assert_not_nil RX::Input.new("<x/>")
    assert_raise(IOError) { assert_not_nil RX::Input.new(File.new('/dev/null')) }
    assert_not_nil RX::Input.new(Dummy1.new)
    assert_raise(ArgumentError) { RX::Input.new(Dummy2.new) }
  end

  def test_encoding_1
    assert_equal(:"UTF-8", RX::Input.new('<foo>').encoding, "From <foo>")
    a = RX::Input.new("<?xml version='1.0' encoding='ISO-8859-1='?><x/>")
    assert_equal(:"LIKE-ASCII", a.encoding, "With XML decl")
  end

  def test_jfc_next_chars
    weekly_chars =
      [ 60, 63, 120, 109, 108, 32, 118, 101, 114, 115, 105, 111, 110, 61, 34,
        49, 46, 48, 34, 63, 62, 13, 10, 60, 33, 68, 79, 67, 84, 89, 80, 69,
        32, 36913, 22577, 32, 83 ]
    files =
      [ 'weekly-utf-16.xml',
        'weekly-little-endian.xml',
        'weekly-utf-8.xml' ]

    files.each do |fname|
      input = RX::Input.new(File.new("#{@base}/xmlconf/japanese/#{fname}"))
      if fname == 'weekly-utf-8.xml'
        input.encoding = 'UTF8'
      end
      buf = []
      weekly_chars.each_index do |i|
        if buf.empty?
          buf = input.next_chars
        end
        assert_equal(weekly_chars[i], buf.shift,
                     "file #{fname}, char #{i}")
      end
    end
  end

  
  def test_japanese_files_initial_encoding
    encodings = {
      'pr-xml-little-endian.xml' => :"UTF-16LE",
      'pr-xml-utf-16.xml' => :"UTF-16BE",
      'pr-xml-utf-8.xml' => :"LIKE-ASCII",
      'weekly-utf-16.xml' => :"UTF-16BE",
      'weekly-little-endian.xml' => :"UTF-16LE",
      'weekly-utf-8.xml' => :"LIKE-ASCII"
    }
    encodings.each do |file, encoding|
      a = RX::Input.new(File.new("#{@base}/xmlconf/japanese/#{file}"))
      assert_equal(encoding, a.encoding, "OUCH: #{file}")
    end
  end
end
