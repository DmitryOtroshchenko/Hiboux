Keyboards

- Tons of good ideas, trackpoint attachment, sculptured 3D printed keyboard with DataHand-like thumb cluster. Amazing! [http://deskthority.net/workshop-f7/my-diy-keyboard-collection-or-how-i-became-a-kb-geek-t2534.html]

- Nice thoughts on switch holes diameters. [http://thume.ca/2014/09/08/creating-a-keyboard-1-hardware/]

- I would assign the thumb buttons in vertical pairs that can be pressed together, such as Ctrl and Alt or Shift and Fn for easier combinations. The outer thumb keys look like they'd be a bit of a stretch, so I'd use them for quite seldom used keys, but the inner 4 thumb keys all look nicely accessible.

- WASD FJ keys

- Katy keyboard

    - That looks neat! I believe I stumbled onto your post before while doing research. Did you write the SPI support for your RJ45 connection? I realized in order for function layers to work properly, I will need to connect these via some sort of communications relay. I was thinking of going for I2C over TRSS so I could just use the I2C code already in the ergodox branch of the tmk_firmware, despite my experience with the TRSS ports on my ergodox and the stuff I can find about I2C on the internet.
    I use SPI for connection of an additional external EEPROM. The code is working. I can write and read the EEPROM at 8MHz clock.
    As for as the connection of the left and the right side, I do not use SPI there. I considered it as an alternative but a solution with two shift registers is simpler and quicker. So, the left side only contains two shift registers to scan the matrix. This needs only 6 wires (Vcc, GND, dataOut, dataIn, clk_74hc164, clk_74hc165). SPI port expander would need 6 wires too. So there is no difference there. A piece of ethernet cable works fine.

- Oobly build (GH)

    - Layer BTN, Layer + Shift [https://geekhack.org/index.php?topic=49721.0]

    - I have a suggestion, though not easy to explain so please ask if I'm not clear. Staggering between regular keyboard row is not regular (from top to bottom for the 4 main rows it's 0.5, 0.25, 0.5). I see that you used the 0.5 offset between your index finger and middle finger, and the 0.25 offset between the middle finger and ring finger. This may seem natural since as most men you have a ring finger longer than your index.

    However the index finger has more "controlling hardware" in the arm (muscles, tendons, etc.) than the ring finger, so it's more agile and may move longer distances more easily. Did you have a try reversing the staggering order so that you get a shorter offset between the index finger and middle finger, and a longer one between the middle finger and the ring finger? To test it you can either put each keypad upside down, or swap them. It might be more comfortable.

- [https://github.com/rsheldiii/openSCAD-projects] KBD - DCS keycaps models

- How to build TMK keyboard guide. [http://deskthority.net/workshop-f7/how-to-build-your-very-own-keyboard-firmware-t7177.html#p141386]

- TMK home on deskthority [http://deskthority.net/workshop-f7/tmk-keyboard-firmware-collection-t4478.html]

- Yogitype - a vertical keyboard

- BrownFox, build log with nice explanations [http://deskthority.net/workshop-f7/brownfox-step-by-step-t6050.html]

- Yager's keyboard [http://yager.io/keyboard/keyboard.html]. Looks solid, with custom firmware and I2P. Custom PCB.

- Atreus keyboard [https://github.com/technomancy/atreus]. Nice multilayer layout.

- Esrille - rare japaneese keyboard, similar to Atreus.

- Rivertron - a nice project with sculptured bottom row. Unique bottom row shaping. [http://deskthority.net/workshop-f7/the-rivertron-keyboard-t1111.html?hilit=rivertron]

- Ergodox tilt stands [https://github.com/bchociej/ergodox-stand] [https://github.com/adereth/ergodox-tent] otherwise kinesis stand.

- Ergohox EZ stand [https://www.indiegogo.com/projects/ergodox-ez-an-incredible-mechanical-keyboard#/story]

- A cheap Teensy alternative [https://github.com/mchck]

- A good idea about pinky row sculpturing [http://deskthority.net/workshop-f7/the-rivertron-keyboard-t1111.html?hilit=rivertron]
