require "./ext"

class HIDAPI
  VERSION = "0.1.0"

  getter devices : Array(DeviceInfo)

  def initialize
    devs = LibHIDAPI.hid_enumerate(0x0, 0x0)
    cur_dev = devs
    @devices = [] of DeviceInfo

    while cur_dev
      info = cur_dev.value

      @devices << DeviceInfo.new(info)

      cur_dev = info.next
    end
  end

  def version : String
    String.new(LibHIDAPI.hid_version_str)
  end
end

require "./hidapi/*"
