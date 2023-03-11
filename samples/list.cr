require "../src/hidapi/lib_hidapi"

MAX_STR = 255

devs = LibHIDAPI.hid_enumerate(0x0, 0x0)
cur_dev = devs

version = LibHIDAPI.hid_version.value
puts "#{version.major}.#{version.minor}.#{version.patch}"
puts String.new(LibHIDAPI.hid_version_str)

while cur_dev
  info = cur_dev.value # LibHIDAPI::HidDeviceInfo
  p! info

  handle = LibHIDAPI.hid_open(info.vendor_id, info.product_id, info.serial_number)
  # handle = LibHIDAPI.hid_open_path(info.path)
  p! handle

  serial_number = info.serial_number.value
  # p! serial_number

  # FIXME Invalid memory access (signal 11) at address 0x10
  # LibHIDAPI.hid_get_device_info(handle)
  # LibHIDAPI.hid_get_manufacturer_string(handle, out str, MAX_STR)

  LibHIDAPI.hid_close(handle)


  cur_dev = info.next

  puts
end

LibHIDAPI.hid_free_enumeration(devs)
