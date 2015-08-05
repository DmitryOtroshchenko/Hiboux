
// Standard keycap size unit.
KEY_WIDTH = 18.4;
KEYCAP_TO_PLATE_OFFSET = 6.7;

// Standard spacing between keys.
SINGLE = 19;
SINGLE_AND_HALF = SINGLE * 1.5;
DOUBLE = SINGLE * 2;

// Cherry MX hole width.
STANDARD_HOLE_SIZE = 13.97;
// Adjusted hole width for tighter keys fit.
HOLE_SIZE_ADJUSTMENT = -0.1;
HOLE_SIZE = STANDARD_HOLE_SIZE + HOLE_SIZE_ADJUSTMENT;


module switch_hole(position, is_double=false) {
    SWITCH_OFFSET = (SINGLE - HOLE_SIZE) / 2;
    translate(position) {
        translate([SWITCH_OFFSET, SWITCH_OFFSET, 0]) {
            if (is_double) {
                square([HOLE_SIZE, SINGLE + HOLE_SIZE]);
            } else {
                square([HOLE_SIZE, HOLE_SIZE]);
            }
        }
    }
};
