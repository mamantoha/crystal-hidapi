require "../src/hidapi/lib_hidapi"

# Get the Sony PlayStation 5 DualSense controller battery level
# Tested on Linux

# https://github.com/torvalds/linux/blob/master/drivers/hid/hid-playstation.c
# https://github.com/nowrep/dualsensectl

DS_VENDOR_ID  = 0x054c
DS_PRODUCT_ID = 0x0ce6

DS_INPUT_REPORT_BT_SIZE = 78

# Status field of DualSense input report
DS_STATUS_BATTERY_CAPACITY =  0xF
DS_STATUS_CHARGING         = 0xF0
DS_STATUS_CHARGING_SHIFT   =    4

devs = LibHIDAPI.hid_enumerate(0x0, 0x0)
cur_dev = devs

while cur_dev
  info = cur_dev.value

  unless info.vendor_id == DS_VENDOR_ID && info.product_id == DS_PRODUCT_ID
    cur_dev = info.next

    next
  end

  handle = LibHIDAPI.hid_open(info.vendor_id, info.product_id, info.serial_number)

  buf = uninitialized UInt8[DS_INPUT_REPORT_BT_SIZE]
  res = LibHIDAPI.hid_read(handle, buf, DS_INPUT_REPORT_BT_SIZE)

  status = buf[54]
  battery_data = status & DS_STATUS_BATTERY_CAPACITY
  charging_status = (status & DS_STATUS_CHARGING) >> DS_STATUS_CHARGING_SHIFT

  case charging_status
  when 0x0
    # Each unit of battery data corresponds to 10%
    # * 0 = 0-9%, 1 = 10-19%, .. and 10 = 100%
    battery_capacity = battery_data * 10 + 5
    battery_status = "discharging"
  when 0x1
    battery_capacity = battery_data * 10 + 5
    battery_status = "charging"
  when 0x2
    battery_capacity = 100
    battery_status = "full"
  when 0xb # temperature error
    battery_capacity = 0
    battery_status = "not-charging"
  else
    # when 0xa # voltage or temperature out of range
    # when 0xf # charging error
    battery_capacity = 0
    battery_status = "unknown"
  end

  puts "#{battery_capacity} #{battery_status}"

  LibHIDAPI.hid_close(handle)

  cur_dev = info.next
end

LibHIDAPI.hid_free_enumeration(devs)
