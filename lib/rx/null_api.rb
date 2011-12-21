module RX

  class NullAPI

    def method_missing(*args)
      # whatever
      return true if args[0] == :end
      nil
    end
  end

end
