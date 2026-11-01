# raspberry bay wiring

[#raspberry-bay-wiring](#raspberry-bay-wiring)

canonical wiring for the bay. use the net names below on both ends in kicad, matching label is the connection.

> [!NOTE]
> sw1 (dip switch) breaks the 5v line between the tp4056 and the mt3608, so it cuts the whole bay including the pi. no switched target rail. the soic clip vcc comes from the pi 3v3 (pin 17).

* * *

## net names

[#net-names](#net-names)

| net        | voltage                | from / to                   |
|------------|------------------------|-----------------------------|
| `+5V`      | 5v                     | mt3608 vout+, pi pin 2      |
| `GND`      | 0v                     | all ground pins             |
| `VBAT`     | 3.7v cell              | tp4056 b+, battery positive |
| `TP_OUT`   | 3.7 to 4.2v, protected | tp4056 out+, sw1 com        |
| `SW_OUT`   | 3.7v, switched         | sw1, mt3608 vin+            |
| `SPI_MOSI` | 3v3 logic              | pi pin 19, soic pin 5       |
| `SPI_MISO` | 3v3 logic              | pi pin 21, soic pin 2       |
| `SPI_SCLK` | 3v3 logic              | pi pin 23, soic pin 6       |
| `SPI_CS`   | 3v3 logic              | pi pin 24, soic pin 1       |

## pi zero 2w header, wired pins only (physical pin numbers)

[#pi-zero-2w-header-wired-pins-only](#pi-zero-2w-header-wired-pins-only)

| pin | net            | goes to              |
|-----|----------------|----------------------|
| 2   | `+5V`          | from mt3608 vout+    |
| 6   | `GND`          | from mt3608 vout -   |
| 17  | `+3V3`         | feeds soic vcc, wp#, hold# |
| 19  | `SPI_MOSI`     | soic pin 5 (si)      |
| 21  | `SPI_MISO`     | soic pin 2 (so)      |
| 23  | `SPI_SCLK`     | soic pin 6           |
| 24  | `SPI_CS` (ce0) | soic pin 1           |
| 25  | `GND`          | soic pin 4           |

pins 27 through 40 are unused and exposed on the bezel as spare bus rail.

## modules

[#modules](#modules)

- usb-c to tp4056 `IN+` and `IN-` (5v charge in).
- tp4056: in from usb-c. `B+` and battery + share `VBAT`. `B-` and battery - share `GND`. `OUT+` is `TP_OUT`. `OUT-` is `GND`.
- sw1 (spdt, master on/off): `COM` on `TP_OUT`, on pole on `SW_OUT`, off leaves it open.
- mt3608: `VIN+` on `SW_OUT`, `VIN-` on `GND`, `VOUT+` on `+5V`, `VOUT-` on `GND`.

## soic8 clip (25 series flash)

[#soic8-clip-25-series-flash](#soic8-clip-25-series-flash)

| pin | signal | net        |
|-----|--------|------------|
| 1   | cs#    | `SPI_CS`   |
| 2   | so     | `SPI_MISO` |
| 3   | wp#    | `+3V3`     |
| 4   | gnd    | `GND`      |
| 5   | si     | `SPI_MOSI` |
| 6   | sclk   | `SPI_SCLK` |
| 7   | hold#  | `+3V3`     |
| 8   | vcc    | `+3V3`     |

> [!WARNING]
> keep wp# (pin 3) and hold# (pin 7) tied to vcc. if hold# goes low the chip's miso goes high impedance and it never answers.
