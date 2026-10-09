# raspberry-bay
raspberry pi zero 2w living inside a thinkpads t60 ultrabay

The Ultrabay slot where the T60's DVD drive used to live is dead weight on a modern FrankenPad. Raspberry Bay fills it with a Raspberry Pi Zero 2 W running headless Pi OS 64-bit. a second hidden Linux computer tucked inside the laptop, with its own battery so it runs whether the host is on or off.

What it does

Embedded SPI flashing rig: a breakout on the front bezel exposes the Pi's SPI0 and UART and GPIO, so you clip a SOIC8 onto a chip and flash it with flashrom (linux_spi)  great for Libreboot/coreboot work and general bus poking.
0.91" OLED on the front shows live CPU,RAM,free storage,IP.
DIP switch kills target power independently of the Pi, so you can flash in-system without supply contention.

How it's built

Pi Zero 2 W + 0.91" I²C OLED + 2×20 right-angle header (the header is the bus rail)
Self-powered: LiPo 803040 → TP4056 USB-C charger → MT3608 boost to 5V
Custom 3D-printed caddy + bezel. The OLED is taller than the 9.5 mm bay, so it sits in a "pod" that bumps out through the slot while everything else stays flush.
