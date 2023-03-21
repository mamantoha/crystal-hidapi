require "../src/hidapi/lib_hidapi"

# Get Sony DualShock4 (2nd gen) controller battery capacity and status.
# Tested on Linux.

# https://github.com/torvalds/linux/blob/master/drivers/hid/hid-playstation.c

DS4_VID = 0x054C
DS4_PID = 0x09CC

DS4_INPUT_REPORT_BT_SIZE = 78

# Status field of DualShock4 input report.
DS4_STATUS0_BATTERY_CAPACITY =  0xF
DS4_STATUS0_CABLE_STATE      = 0x10
# Battery status within batery_status field.
DS4_BATTERY_STATUS_FULL = 11

devs = LibHIDAPI.hid_enumerate(0x0, 0x0)
cur_dev = devs

while cur_dev
  info = cur_dev.value

  unless info.vendor_id == DS4_VID && info.product_id == DS4_PID
    cur_dev = info.next

    next
  end

  handle = LibHIDAPI.hid_open(info.vendor_id, info.product_id, info.serial_number)

  buf = uninitialized UInt8[DS4_INPUT_REPORT_BT_SIZE]
  res = LibHIDAPI.hid_read(handle, buf, DS4_INPUT_REPORT_BT_SIZE)

  # p! buf[3] # left stick horizontal
  # p! buf[4] # left stick vertical

  # p! buf

  battery_capacity = 100 # initial value until parse_report.
  battery_status = nil

  status = buf[32]
  battery_data = status & DS4_STATUS0_BATTERY_CAPACITY
  p! battery_data

  # Interpretation of the battery_capacity data depends on the cable state.
  # When no cable is connected (bit4 is 0):
  # - 0:10: percentage in units of 10%.
  # When a cable is plugged in:
  # - 0-10: percentage in units of 10%.
  # - 11: battery is full
  # - 14: not charging due to Voltage or temperature error
  # - 15: charge error
  unless (status & DS4_STATUS0_CABLE_STATE).zero?
    if battery_data < 10
      # Take the mid-point for each battery capacity value,
      # because on the hardware side 0 = 0-9%, 1=10-19%, etc.
      # This matches official platform behavior, which does
      # the same.
      battery_capacity = battery_data * 10 + 5
      battery_status = "charging"
    elsif battery_data == 10
      battery_capacity = 100
      battery_status = "charging"
    elsif battery_data == DS4_BATTERY_STATUS_FULL
      battery_capacity = 100
      battery_status = "full"
    else # 14, 15 and undefined values
      battery_capacity = 0
      battery_status = "unknown"
    end
  else
    if battery_data < 10
      battery_capacity = battery_data * 10 + 5
    else # 10
      battery_capacity = 100
    end

    battery_status = "discharging"
  end

  puts "#{battery_capacity} #{battery_status}"

  LibHIDAPI.hid_close(handle)

  cur_dev = info.next
end

LibHIDAPI.hid_free_enumeration(devs)
