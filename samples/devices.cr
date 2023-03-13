require "../src/crystal-hidapi"

hidapi = HIDAPI.new

hidapi.devices.each do |device|
  puts device
end
