$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require 'qname.rb'
require 'reader.rb'


class TestInput < Test::Unit::TestCase

  def namespace_binding pref
    case pref
    when 'foo' then 'http://bar/'
    when 'xxx' then 'http://yyy/'
    end
  end

  def test_scan
    a = [ 'foo:bar', 'xxx:a', 'x', 'y', 'z' ]
    a = a.map { |x| x.explode }
    ns = {}
    a = RX::QName.scan(a, ns, self)
    assert_kind_of(Array, a)
    assert_equal(0, ns.size)
    [0, 1, 3].each { |i| assert_kind_of(RX::QName, a[i]) }
    a = [ 'foo:bar', 'yyy:a', 'x', 'y', 'z' ]
    a = a.map { |x| x.explode }
    a = RX::QName.scan(a, ns, self)
    assert_kind_of(String, a)
  end

  def test_new
    @q = RX::QName.new('http://bar/', 'foo', 'a')
    assert_equal('http://bar/', @q.namespace)
    assert_equal('foo', @q.prefix)
    assert_equal('a', @q.local_part)
  end

  def test_split
    a = 'abc:def'.explode
    b, c = RX::QName.split(a)
    assert_equal('abc', b)
    assert_equal('def', c)
    a = 'aa'.explode
    b, c = RX::QName.split(a)
    assert_equal('', b)
    assert_equal('aa', c)

  end

  def test_from_bytes
    a = 'foo:a'.explode
    q = RX::QName.from_bytes(a, self)
    assert_kind_of(RX::QName, q)
    assert_equal('http://bar/', q.namespace)
    assert_equal('foo', q.prefix)
    assert_equal('a', q.local_part)
  end

  def test_equal
    a = RX::QName.new('http://bar/', 'x', 'a')
    b = RX::QName.new('http://bar/', 'foo', 'a')

    assert_equal(a, b)
    b = RX::QName.new('http://bar/', 'x', 'b')
    assert_not_equal(a, b)
  end

  def test_try_new
    q = RX::QName.try_new(['foo', 'a'], self)
    assert_kind_of(RX::QName, q)
    q = RX::QName.try_new(['bar', 'a'], self)
    assert_kind_of(String, q)
  end

end
