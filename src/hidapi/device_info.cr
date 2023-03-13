struct HIDAPI::DeviceInfo
  getter path : String
  getter vendor_id : Int32
  getter product_id : Int32
  getter serial_number : String
  getter release_number : Int32
  getter manufacturer_string : String
  getter product_string : String
  getter usage_page : Int32
  getter usage : Int32
  getter interface_number : Int32
  getter bus_type : BusType

  enum BusType
    Unknown   # 0
    Usb       # 1
    Bluetooth # 2
    I2C       # 3
    Spi       # 4
  end

  def initialize(info : LibHIDAPI::HidDeviceInfo)
    @path = String.new(info.path)
    @vendor_id = info.vendor_id.to_i
    @product_id = info.product_id.to_i
    @serial_number = String.new(info.serial_number)
    @release_number = info.release_number.to_i
    @manufacturer_string = String.new(info.manufacturer_string)
    @product_string = String.new(info.product_string)
    @usage_page = info.usage_page.to_i
    @usage = info.usage.to_i
    @interface_number = info.interface_number
    @bus_type = BusType.new(info.bus_type.to_i)
  end
end
