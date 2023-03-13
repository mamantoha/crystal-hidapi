require "../src/hidapi/lib_hidapi"

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

devs = LibHIDAPI.hid_enumerate(0x0, 0x0)
cur_dev = devs

while cur_dev
  info = cur_dev.value # LibHIDAPI::HidDeviceInfo
  # p! info
  handle = LibHIDAPI.hid_open(info.vendor_id, info.product_id, info.serial_number)

  path = String.new(info.path)
  p! path

  unless info.serial_number.null?
    ptr = info.serial_number

    serial_number = String.new(ptr)
    p! serial_number
  end

  unless info.manufacturer_string.null?
    ptr = info.manufacturer_string

    manufacturer_string = String.new(ptr)
    p! manufacturer_string

    # LibC.printf("`%ls`", ptr)
  end

  unless info.product_string.null?
    ptr = info.product_string

    product_string = String.new(ptr)
    p! product_string

    # LibC.printf("`%ls`", ptr)
  end

  LibHIDAPI.hid_close(handle)

  cur_dev = info.next

  puts
end

LibHIDAPI.hid_free_enumeration(devs)
