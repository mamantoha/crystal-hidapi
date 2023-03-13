lib LibC
  fun wcslen(s : UInt32*) : SizeT
end

class String
  def self.new(chars : UInt32*)
    raise ArgumentError.new("Cannot create a string with a null pointer") if chars.null?

    new(chars, LibC.wcslen(chars))
  end

  def self.new(chars : UInt32*, bytesize, size = 0)
    return "" if bytesize == 0

    if chars.null?
      raise ArgumentError.new("Cannot create a string with a null pointer and a non-zero (#{bytesize}) bytesize")
    end

    chars.to_slice(bytesize).map(&.chr).join
  end
end
