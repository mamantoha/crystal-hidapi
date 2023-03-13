require "../src/crystal-hidapi"

hidapi = HIDAPI.new
puts hidapi.version
