require "../src/hidapi/lib_hidapi"

devs = LibHIDAPI.hid_enumerate(0x0, 0x0)
cur_dev = devs

version = LibHIDAPI.hid_version.value
puts "#{version.major}.#{version.minor}.#{version.patch}"
puts String.new(LibHIDAPI.hid_version_str)

while cur_dev
  info = cur_dev.value # LibHIDAPI::HidDeviceInfo
  p! info
  p! "0x%.4X" % info.vendor_id
  p! "0x%.4X" % info.product_id

  handle = LibHIDAPI.hid_open(info.vendor_id, info.product_id, info.serial_number)
  # handle = LibHIDAPI.hid_open_path(info.path)
  p! handle

  LibHIDAPI.hid_close(handle)

  cur_dev = info.next

  puts
end

LibHIDAPI.hid_free_enumeration(devs)
