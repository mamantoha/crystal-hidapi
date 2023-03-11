@[Link("hidapi-hidraw")]
lib LibHIDAPI
  fun hid_init : LibC::Int
  fun hid_exit : LibC::Int
  struct HidDeviceInfo
    path : LibC::Char*
    vendor_id : LibC::UShort
    product_id : LibC::UShort
    serial_number : WcharT*
    release_number : LibC::UShort
    manufacturer_string : WcharT*
    product_string : WcharT*
    usage_page : LibC::UShort
    usage : LibC::UShort
    interface_number : LibC::Int
    next : HidDeviceInfo*
    bus_type : HidBusType
  end
  alias WcharT = LibC::Int
  enum HidBusType
    HidApiBusUnknown = 0
    HidApiBusUsb = 1
    HidApiBusBluetooth = 2
    HidApiBusI2C = 3
    HidApiBusSpi = 4
  end
  fun hid_enumerate(vendor_id : LibC::UShort, product_id : LibC::UShort) : HidDeviceInfo*
  fun hid_free_enumeration(devs : HidDeviceInfo*)
  type HidDevice = Void*
  fun hid_open(vendor_id : LibC::UShort, product_id : LibC::UShort, serial_number : WcharT*) : HidDevice
  fun hid_open_path(path : LibC::Char*) : HidDevice
  fun hid_write(dev : HidDevice, data : UInt8*, length : LibC::SizeT) : LibC::Int
  fun hid_read_timeout(dev : HidDevice, data : UInt8*, length : LibC::SizeT, milliseconds : LibC::Int) : LibC::Int
  fun hid_read(dev : HidDevice, data : UInt8*, length : LibC::SizeT) : LibC::Int
  fun hid_set_nonblocking(dev : HidDevice, nonblock : LibC::Int) : LibC::Int
  fun hid_send_feature_report(dev : HidDevice, data : UInt8*, length : LibC::SizeT) : LibC::Int
  fun hid_get_feature_report(dev : HidDevice, data : UInt8*, length : LibC::SizeT) : LibC::Int
  fun hid_get_input_report(dev : HidDevice, data : UInt8*, length : LibC::SizeT) : LibC::Int
  fun hid_close(dev : HidDevice)
  fun hid_get_manufacturer_string(dev : HidDevice, string : WcharT*, maxlen : LibC::SizeT) : LibC::Int
  fun hid_get_product_string(dev : HidDevice, string : WcharT*, maxlen : LibC::SizeT) : LibC::Int
  fun hid_get_serial_number_string(dev : HidDevice, string : WcharT*, maxlen : LibC::SizeT) : LibC::Int
  fun hid_get_device_info(dev : HidDevice) : HidDeviceInfo*
  fun hid_get_indexed_string(dev : HidDevice, string_index : LibC::Int, string : WcharT*, maxlen : LibC::SizeT) : LibC::Int
  fun hid_error(dev : HidDevice) : WcharT*
  struct HidApiVersion
    major : LibC::Int
    minor : LibC::Int
    patch : LibC::Int
  end
  fun hid_version : HidApiVersion*
  fun hid_version_str : LibC::Char*
end
