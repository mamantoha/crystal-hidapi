# crystal-hidapi

A Crystal interface to [HIDAPI](https://github.com/libusb/hidapi) library.

It works on Linux and macOS.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crystal-hidapi:
       github: mamantoha/crystal-hidapi
   ```

2. Run `shards install`

### Compile time dependencies

You need to install the development package for `hidapi`

- macOS: `brew install hidapi`
- Arch Linux: `pacman -S hidapi`
- Ubuntu: `apt install libhidapi-dev`

## Usage

```crystal
require "crystal-hidapi"
```

## Development

```
crystal ./lib/crystal_lib/src/main.cr src/hidapi/lib_hidapi.cr.in > src/hidapi/lib_hidapi.cr
```

- https://github.com/libusb/hidapi
- https://github.com/libusb/hidapi/blob/master/hidapi/hidapi.h
- https://github.com/libusb/hidapi/blob/master/hidtest/test.c
- https://github.com/todbot/hidapitester/blob/master/hidapitester.c

## Contributing

1. Fork it (<https://github.com/mamantoha/crystal-hidapi/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Anton Maminov](https://github.com/mamantoha) - creator and maintainer
