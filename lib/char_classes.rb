module RX

  class CharClass
    CLASSES = {
      'S' => " \t\n\r",
      'NameStart' => 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
      'NameC' =>
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-.0123456789_:',
      'Hex' => '0123456789abcdefABCDEF',
      'PubID' =>
      " \n\rabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-\'()+,./:=?",
      'EncName' => 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ._-'
    }
    
    # from XML 1.0 "#x9 | #xA | #xD | [#x20-#xD7FF] "
    dot = [ 0x9, 0xa, 0xd ]
    0x20.upto(127) { |c| dot << c }
    CLASSES['.'] = dot.pack('C*')

    def CharClass.bytes(classname)
      CLASSES[classname]
    end

    def CharClass.is_in(c, class_name)
      POINTS[class_name].index(c) ||
        RANGES[class_name].any? { |r| r.member?(c) }
    end
  end
end
