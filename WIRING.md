Raspberry Bay Wiring diagram

SW1 (SPDT) breaks the 3.7 V line between the TP4056 and the MT3608, so it
cuts the whole bay including the Pi. No DIP, no switched target rail. The
SOIC clip VCC comes from the Pi 3V3 (pin 17).

Net names

Use these exact names on both ends in KiCad. Matching label is the connection.

- `+5V` (5 V): MT3608 VOUT+, Pi pin 2
- `+3V3` (3.3 V): Pi pin 1, Pi pin 17, OLED VCC, SOIC pins 3, 7, 8
- `GND`: all ground pins
- `VBAT` (3.7 V cell): TP4056 B+, battery positive
- `TP_OUT` (protected 3.7 to 4.2 V): TP4056 OUT+, SW1 COM
- `SW_OUT` (switched 3.7 V): SW1, MT3608 VIN+
- `I2C_SDA`: Pi pin 3, OLED SDA
- `I2C_SCL`: Pi pin 5, OLED SCL
- `SPI_MOSI`: Pi pin 19, SOIC pin 5
- `SPI_MISO`: Pi pin 21, SOIC pin 2
- `SPI_SCLK`: Pi pin 23, SOIC pin 6
- `SPI_CS`: Pi pin 24, SOIC pin 1

Pi Zero 2 W header

Wired pins only (physical pin numbers):

- Pin 1: `+3V3`, feeds OLED VCC
- Pin 2: `+5V`, from MT3608 VOUT+
- Pin 3: `I2C_SDA`, to OLED
- Pin 5: `I2C_SCL`, to OLED
- Pin 6: `GND`, from MT3608 VOUT negative
- Pin 9: `GND`, to OLED
- Pin 17: `+3V3`, feeds SOIC VCC, WP#, HOLD#
- Pin 19: `SPI_MOSI`, to SOIC pin 5 (SI)
- Pin 21: `SPI_MISO`, to SOIC pin 2 (SO)
- Pin 23: `SPI_SCLK`, to SOIC pin 6
- Pin 24: `SPI_CS` (CE0), to SOIC pin 1
- Pin 25: `GND`, to SOIC pin 4

Pins 27 through 40 are unused and exposed on the bezel as spare bus rail.

Modules

USB-C: goes to TP4056 IN+ and IN negative (5 V charge in).

TP4056: IN from USB-C. B+ and battery positive share `VBAT`. B negative
and battery negative share `GND`. OUT+ is `TP_OUT`. OUT negative is `GND`.

SW1 (SPDT, master on/off): COM on `TP_OUT`. ON pole on `SW_OUT`. Off
position leaves it open.

MT3608: VIN+ on `SW_OUT`. VIN negative on `GND`. VOUT+ on `+5V`. VOUT
negative on `GND`. Trim VOUT to 5.0 V before connecting the Pi.

OLED 0.91" (I2C): VCC on `+3V3`. GND on `GND`. SDA on `I2C_SDA`. SCL on
`I2C_SCL`. Check the silkscreen pin order on your module.

SOIC8 clip (25-series flash)

- Pin 1 CS#: `SPI_CS`
- Pin 2 SO: `SPI_MISO`
- Pin 3 WP#: `+3V3`
- Pin 4 GND: `GND`
- Pin 5 SI: `SPI_MOSI`
- Pin 6 SCLK: `SPI_SCLK`
- Pin 7 HOLD#: `+3V3`
- Pin 8 VCC: `+3V3`
