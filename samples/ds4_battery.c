#include <stdio.h>
#include <stdlib.h>
#include <hidapi/hidapi.h>

// DualShock 4 2nd generation Vendor and Product IDs
#define DS4_VID 0x054c
#define DS4_PID 0x05c4

// Battery level offset in the input report
#define DS4_BATTERY_OFFSET 30

// Function to calculate battery level percentage
int get_battery_percentage(unsigned char battery_data) {
    if (battery_data == 0xEE) {
        return 0;
    }
    int level = battery_data & 0x0F;
    return (level == 0x0F) ? 100 : (level * 100) / 0x0F;
}

int main() {
    if (hid_init() != 0) {
        fprintf(stderr, "Error initializing HIDAPI\n");
        return 1;
    }

    hid_device *handle = hid_open(DS4_VID, DS4_PID, NULL);
    if (handle == NULL) {
        fprintf(stderr, "Error opening DualShock 4 device\n");
        hid_exit();
        return 1;
    }

    unsigned char buf[64];
    int res = hid_read(handle, buf, sizeof(buf));
    if (res > 0) {
        int battery_percentage = get_battery_percentage(buf[DS4_BATTERY_OFFSET]);
        printf("Battery Level: %d%%\n", battery_percentage);
    } else {
        fprintf(stderr, "Error reading from DualShock 4 device\n");
    }

    hid_close(handle);
    hid_exit();
    return 0;
}
