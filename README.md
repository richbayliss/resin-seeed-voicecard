Seeed Voicecard Demo
===

Powered by [Resin.io](https://resin.io)

What it does
---

This is simple app which builds and loads the kernel modules required to use ALSA for sound input & output. Included in the app is a NodeJS sample app which controls the LEDs on the pHAT using the onboard button.

Getting started
---

- Create an account at [https://resin.io](https://resin.io)
- Login and create a new application; starter level is fine
- Add a new device, choose the right hardware (tested on a Pi Zero W) and download the SD card image
- Burn the image to your card using [Etcher](https://etcher.io) (Mac,Windows,Linux)
- Before ejecting the SD card, grab the relevant DTBO/DTS files from the Seeed repo and put them in the `boot` partition of the SD card
  - https://github.com/respeaker/seeed-voicecard
- Safely eject the SD card and hook it up to your Pi
- Attach the Seeed Voicecard to your Pi
- If using Ethernet, connect it to your Pi
- Power up your Pi
- Deploy the project either via Git or the Resin SDK
- Once deployed, and the Pi has downloaded the app, the top LED will light up RED and each button press will change which LED is on



