# raspberry bay
raspberry pi zero 2w living inside a thinkpads t60 ultrabay

The Ultrabay slot where the T60's DVD drive used to live is dead weight on a modern FrankenPad. Raspberry Bay fills it with a Raspberry Pi Zero 2 W running headless Pi OS 64-bit. a second hidden Linux computer tucked inside the laptop, with its own battery so it runs whether the host is on or off.
<img width="4032" height="3024" alt="Image" src="https://github.com/user-attachments/assets/5e5c0b02-1411-4137-895f-5adb5e8694ee" />

# So what it does?

Embedded SPI flashing rig: a breakout on the front bezel exposes the Pi's SPI0 and UART and GPIO, so you clip a SOIC8 onto a chip and flash with flashrom, great for Libreboot/coreboot work and general bus poking.
DIP switch kills targets power.

# How it's built?

<img width="4032" height="3024" alt="Image" src="https://github.com/user-attachments/assets/4323bf2d-97bc-4d09-a57a-0dca265cbb9f" />


Pi Zero 2 W + 2×20 right-angle header (the header is the bus rail)
Self-powered: LiPo 803040 to a TP4056 USB-C charger to MT3608 boost to 5V
Custom 3D-printed caddy.
