# raspberry bay

a raspberry pi zero 2w living inside a thinkpad t60 ultrabay. the slot where the dvd drive used to sit is dead weight on a modern frankenpad, so it now holds a second hidden linux box running headless pi os 64bit, with its own battery so it runs whether the host is on or off. the front bezel breaks out the pi's spi, so you clip a soic8 onto a chip and flash it with flashrom straight out of the laptop. built while i was actually doing it, gotchas left in.

![pi](https://img.shields.io/badge/raspberry%20pi-zero%202w-c51a4a)
![host](https://img.shields.io/badge/host-thinkpad%20t60-black)
![slot](https://img.shields.io/badge/slot-ultrabay-blue)
![os](https://img.shields.io/badge/os-pi%20os%2064bit-green)
![license](https://img.shields.io/badge/license-GPL%203.0-lightgrey)
![status](https://img.shields.io/badge/status-working-success)

> [!NOTE]
> the whole bay runs off its own lipo, charged over usb-c. one switch (sw1) cuts the lot, pi included. theres no separate target rail, the chip under the clip gets its 3v3 straight from the pi.

> [!CAUTION]
> theres a lipo cell sitting inside a laptop chassis. use a protected 803040, keep it away from anything that can pinch or short it, and dont leave it charging unattended the first few times. clipping onto other peoples boards is on you, not me. read [section 6](#6-flashing-a-chip) first.

* * *

## contents

[#contents](#contents)

1. [what it is](#1-what-it-is)
2. [so what it does](#2-so-what-it-does)
3. [how it's built](#3-how-its-built)
4. [power](#4-power)
5. [pinout and wiring](#5-pinout-and-wiring)
6. [flashing a chip](#6-flashing-a-chip)
7. [cost](#7-cost)

* * *

## 1. what it is

[#1-what-it-is](#1-what-it-is)

a pi zero 2w in a 3d printed caddy that drops into the t60 ultrabay where the optical drive was. runs headless pi os 64bit, you reach it over wifi, so its basically a tiny always on linux box that happens to live inside the laptop.

two things make it more than a gimmick:

- its self powered. own lipo plus a boost converter, so it runs no matter what the host is doing. t60 off, asleep, mid flash, the pi keeps going.
- its bus is out. the 2x20 header is the bus rail, spi0 and uart and spare gpio come out on the bezel, so the pi is wired to actually do something.

![raspberry bay in the ultrabay](https://github.com/user-attachments/assets/5e5c0b02-1411-4137-895f-5adb5e8694ee)

## 2. so what it does

[#2-so-what-it-does](#2-so-what-it-does)

main job is being an embedded spi flashing rig. the bezel breakout exposes the pi's spi0, uart and gpio, so you clip a soic8 onto a 25 series flash chip and read or write it with flashrom over linux_spi. great for libreboot/coreboot work on other machines, bios recovery, and general bus poking. no separate programmer to go dig out.

the clip's vcc comes off the pi's own 3v3 (pin 17), which also pulls wp# and hold# high so the chip actually answers.

> [!TIP]
> clip is fed from the pi's 3v3, so this is a 3.3v rig. dont put it on a 5v chip without a level shifter.

## 3. how it's built

[#3-how-its-built](#3-how-its-built)

- pi zero 2w with a 2x20 right angle header. the header is the bus rail.
- self powered: lipo 803040 to a tp4056 usb-c charger to an mt3608 boost to 5v to the pi.
- master switch (sw1), cuts the whole bay. more in [section 4](#4-power).
- custom 3d printed caddy sized to the ultrabay, sources in [`openscad`](openscad).
- kicad schematic for the wiring in [`schematic`](schematic).

![raspberry bay internals](https://github.com/user-attachments/assets/4323bf2d-97bc-4d09-a57a-0dca265cbb9f)

## 4. power

[#4-power](#4-power)

usb-c charges the cell through the tp4056. the bay runs off that cell. sw1 sits between the protected cell output and the boost, so flip it off and everything downstream dies, pi included.

flow: battery to tp4056 to sw1 to mt3608 boost to 5v to the pi.

net names, use these exact ones on both ends in kicad. matching label is the connection.

| net        | voltage           | from / to                   |
|------------|-------------------|-----------------------------|
| `+5V`      | 5v                | mt3608 vout+, pi pin 2      |
| `GND`      | 0v                | all ground pins             |
| `VBAT`     | 3.7v cell         | tp4056 b+, battery positive |
| `TP_OUT`   | 3.7 to 4.2v, protected | tp4056 out+, sw1 com   |
| `SW_OUT`   | 3.7v, switched    | sw1, mt3608 vin+            |

module by module:

- usb-c to tp4056 `IN+` and `IN-` (5v charge in).
- tp4056: in from usb-c. `B+` and battery + share `VBAT`. `B-` and battery - share `GND`. `OUT+` is `TP_OUT`. `OUT-` is `GND`.
- sw1 (spdt, master on/off): `COM` on `TP_OUT`, on pole on `SW_OUT`, off leaves it open.
- mt3608: `VIN+` on `SW_OUT`, `VIN-` on `GND`, `VOUT+` on `+5V`, `VOUT-` on `GND`.

> [!IMPORTANT]
> sw1 cuts the whole bay, not just a target. the pi loses power when you flip it off, so its the bay's main switch, not a way to toggle a chip under the clip mid session.

## 5. pinout and wiring

[#5-pinout-and-wiring](#5-pinout-and-wiring)

only these header pins are wired. everything else on the 2x20 is left as spare bus rail on the bezel.

| pi pin | net            | goes to             |
|--------|----------------|---------------------|
| 2      | `+5V`          | from mt3608 vout+   |
| 6      | `GND`          | from mt3608 vout -  |
| 17     | `+3V3`         | soic vcc, wp#, hold# |
| 19     | `SPI_MOSI`     | soic pin 5 (si)     |
| 21     | `SPI_MISO`     | soic pin 2 (so)     |
| 23     | `SPI_SCLK`     | soic pin 6          |
| 24     | `SPI_CS` (ce0) | soic pin 1          |
| 25     | `GND`          | soic pin 4          |

pins 27 through 40 are unused and exposed on the bezel as spare bus rail.

soic8 clip (25 series flash):

| soic pin | signal | net        |
|----------|--------|------------|
| 1        | cs#    | `SPI_CS`   |
| 2        | so     | `SPI_MISO` |
| 3        | wp#    | `+3V3`     |
| 4        | gnd    | `GND`      |
| 5        | si     | `SPI_MOSI` |
| 6        | sclk   | `SPI_SCLK` |
| 7        | hold#  | `+3V3`     |
| 8        | vcc    | `+3V3`     |

> [!WARNING]
> keep wp# (pin 3) and hold# (pin 7) at vcc. if hold# goes low the chip's miso goes high impedance and it never answers. full canonical wiring is in [`WIRING.md`](WIRING.md).

## 6. flashing a chip

[#6-flashing-a-chip](#6-flashing-a-chip)

`SPI_CS` is on ce0 (pin 24), so the chip shows up as `/dev/spidev0.0`. turn spi on first (`raspi-config` interface options spi, or `dtparam=spi=on` in `/boot/config.txt`), then:

```
# 1. detect + read, writes nothing
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=512 -r dump1.bin

# 2. read again and compare, matching hashes mean reads are stable
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=512 -r dump2.bin
sha256sum dump1.bin dump2.bin

# 3. only then write
flashrom -p linux_spi:dev=/dev/spidev0.0,spispeed=512 -w new.rom
#    must end with: VERIFIED.
```

> [!TIP]
> if it finds the chip but reads wobble or it dies mid write, drop spispeed (try 256 or 128) and make sure the clip is sitting square on all eight legs.

> [!CAUTION]
> flashing a board thats still got its own power causes bus contention, the targets controller fights the pi for the bus and the chip never answers clean. power the target down first, and in stubborn cases power only the chip, before you write.

## 7. cost

[#7-cost](#7-cost)

| part                                 | cost       |
|--------------------------------------|------------|
| raspberry pi zero 2w                 | 20 eur     |
| tp4056 usb-c battery charger         | 1 eur      |
| lipo battery 803040, 1000mah / 3.7v  | 3 eur      |
| mt3608 2a dc-dc step up              | 1 eur      |
| dip switch (2 switch ver)            | 0.20 eur   |
| philips 128gb microsdhc (or any)     | 25 eur     |
| **total**                            | **50.20 eur** |

full breakdown in [`full-cost.md`](full-cost.md).

