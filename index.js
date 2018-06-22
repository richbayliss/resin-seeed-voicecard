const Gpio = require('onoff').Gpio;
const button = new Gpio(17, 'in', 'both');

const Apa102 = require('apa102-spi')
const leds = new Apa102(9, 100)

let count = 3;
button.watch(function (err, value) {
    if (value === 0) {
        // setLedColor(n, brightness 0-31, red 0-255, green 0-255, blue 0-255)
        leds.setLedColor(0, 0, 255, 0, 0);
        leds.setLedColor(1, 0, 255, 0, 0);
        leds.setLedColor(2, 0, 255, 0, 0);

        leds.setLedColor(count % 3, 3, 255, 0, 0);
        leds.sendLeds();

        console.log('Click!');
        count++;
    }
});

console.log('Listening for button presses...');