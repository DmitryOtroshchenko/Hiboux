
- Another thought about acrylic mount plates. It may be possible to use a 1.5mm switch mount plate and glue it to a 6mm (or any thickness you want) plate that has oversize switch holes (say 1-1.5mm all around). So the switches mount correctly to the 1.5mm sheet and are held firmly by the supporting thicker plate. You can probably even have cutouts in the 1.5mm plate to allow for opening the switches when mounted, due to the support being really close.

- Make teensy visible under the acrylic: under the palm or on top of the KB

- Scroll wheel. Use capacitive like [http://pcbgadgets.com/index.php?route=product/product&product_id=54]?

- Use trackpoint-like stick as a scrolling wheel.

- Capacitive trackpad. [https://itp.nyu.edu/archive/physcomp-spring2014/sensors/Reports/Trackpad.html]

- Sculptured thumb cluster in order to create a kind of half-pipe.

- A nice trackball: [https://www.sparkfun.com/products/9320] "trackball breakboard"

https://www.sparkfun.com/products/10063 5dir (x,y,click), smd, $2. no rubber nub, probably one of lenovo wil fit, not sure.

https://www.sparkfun.com/products/11187 same with board, $6

https://www.sparkfun.com/products/9032 thumb stick with rubber dome, $4, arduino code example given

https://www.sparkfun.com/products/10835 hall effect joystick with click, relatively cheap for hall effect ones ($20)

I've also ordered c&k components TSW and JS1300AQ 'joysticks', ($10 and $2), but pretty sure they are not 'analog', and can only provide direction, not pressure force. first one comes with jog wheel though.

- Trackpoint guide: [https://geekhack.org/index.php?topic=55960.0] [https://geekhack.org/index.php?topic=50176.30]

- Big trackball under the palm activated by holding a key on the keyboard. Trackball under the left palm, activator key under the right palm.

- Add a mini->micro usb converter.

- Nice FN layer layout

```
     !     @     {     }     |       ||     pgup    7     8     9    *
     #     $     (     )     `       ||     pgdn    4     5     6    +
     %     ^     [     ]     ~       ||       &     1     2     3    \
    L2  insert super shift bksp ctrl || alt space   fn    .     0    =
```

```
----- M2 / special ---
@  _  [  ]  #     !  <  >  =  &
\  /  {  }  *     ?  (  )  +  :
$  |  ~  `     ^  %  "  '

----- M3 / Movement & Numbers ---
PgUp BkSp  Up  Del  PgDo   ß 7 8 9 ä
Pos1 Left Down Righ End    . 4 5 6 ö
Esc  Tab  Ins  Ret  Undo   0 1 2 3 ü
```

- Cherry MX Reds for modifier keys.

- Use sensor bracelet. [https://www.thalmic.com/myo/]

- One thing I miss from my Ergodox is having a "Teensy reset" key; if that's a feature of the tmk firmware, I haven't been able to find it yet. So all my firmware changes require pulling the case apart, which is a little annoying.

[https://github.com/shayneholmes/tmk_keyboard/blob/simon_layout/keyboard/ergodox/keymap_simon.h]
[https://github.com/technomancy/tmk_keyboard/commit/cb4ea37a2e6b03519269b8be5c1ed5a0b785e9de]

You need to add these lines to the relevant parts of your keymap.h file:

```
enum function_id {
    TEENSY_KEY,
};

static const uint16_t PROGMEM fn_actions[] = {
    ACTION_FUNCTION(TEENSY_KEY), // FN4 - Teensy key
};

void action_function(keyrecord_t *record, uint8_t id, uint8_t opt)
{
    keyevent_t event = record->event;

    if (id == TEENSY_KEY) {
        clear_keyboard();
        print("\n\nJump to bootloader... ");
        _delay_ms(250);
        bootloader_jump(); // should not return
        print("not supported.\n");
    }
}
```

And also put a FN0, or whatever entry number it is in the Actions list, onto whatever key you want it to be in the layout. I snipped the other lines out of the code I just quoted, but it was FN4 on that layout.

- Typing dotted numbers right now is *very* annoying (like 127.0.0.1) because you have to go back and forth between the fn layer and the unshifted layer. I might make a separate layer just for a numpad to address this.

- Add a number input layer that everything you need to type a number / date / IP / ...

- I also added automatic matched brakets, etc. which enter both opening and closing brackets and then moves the cursor back between them.

- There exists "solderable magnet wire" - wire covered with enamel istead of the ordinary insulation. It is more resistant to scratches and high temperatures.

- I also just yesterday implemented what I'm calling "double-duty" fn: when you hold fn with another keypress, it acts as a momentary shift to layer 1, but when you just tap it, it brings you to layer 2 till you tap it again to go back to layer 0.

- QCAD and DraftSight

- KiCAD for PCB design

- About making a PCB:

* thicker traces (3mm)
* move the diodes to the side instead of sitting under the switches
* avoid routing traces through diode through-holes
* keep traces closer together and don't let them get to close to unconnected through-holes

- keyboard.io evolution [http://blog.fsck.com/2013/12/better-and-better-keyboards.html]

- Wooden glossy case?
