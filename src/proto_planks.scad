    

SWITCH_HOLE_SIZE = 13.97;

SINGLE = 19;
QUARTER = 1.25 * SINGLE;
HALF = 1.5 * SINGLE;
DOUBLE = 2 * SINGLE;

ROW_SPACING = SINGLE;
SWITCH_OFFSET = (SINGLE - SWITCH_HOLE_SIZE) / 2;

N_ROWS = 4;


module switch_hole(position) {
    // Cherry MX switch hole with the center at `position`. Sizes come
    // from the ErgoDox design.

    position = [
        position[0] + SWITCH_OFFSET,
        position[1] + SWITCH_OFFSET
    ];

    hole_size = SWITCH_HOLE_SIZE;
    translate(position) {
        square([hole_size, hole_size]);
    }
};


// switch_hole([0,0,0]);


module fix_hole(position) {
    FIX_HOLE_RADIUS = 2;
    translate(position) {
        circle(FIX_HOLE_RADIUS);
    }
};


// fix_hole([0,0,0]);


module switch_plank_outer(position) {
    PLANK_UPPER_SPACE = SINGLE;
    PLANK_LOWER_SPACE = SINGLE;

    translate(position) {
        difference() {
            square([QUARTER, PLANK_LOWER_SPACE + DOUBLE + 2 * SINGLE + PLANK_UPPER_SPACE]);
            translate([0, PLANK_LOWER_SPACE, 0]) {
                switch_hole([(QUARTER - SINGLE) / 2, 2 * SINGLE]);
                switch_hole([(QUARTER - SINGLE) / 2, 3 * SINGLE]);
                switch_hole([QUARTER - SINGLE, 0.5 * SINGLE]);
            }
            fix_hole([QUARTER / 2, PLANK_LOWER_SPACE / 2, 0]);
            fix_hole([QUARTER / 2, PLANK_LOWER_SPACE + DOUBLE + 2 * SINGLE + PLANK_UPPER_SPACE / 2, 0]);
        }
    }
}


module switch_plank_simple(position, n_rows=N_ROWS) {
    PLANK_UPPER_SPACE = SINGLE;
    PLANK_LOWER_SPACE = SINGLE;

    translate(position) {
        difference() {
            square([SINGLE, PLANK_LOWER_SPACE + 4 * SINGLE + PLANK_UPPER_SPACE]);
            translate([0, PLANK_LOWER_SPACE, 0]) {
                switch_hole([0, 0 * SINGLE]);
                switch_hole([0, 1 * SINGLE]);
                switch_hole([0, 2 * SINGLE]);
                switch_hole([0, 3 * SINGLE]);
            }
            fix_hole([SINGLE / 2, PLANK_LOWER_SPACE / 2, 0]);
            fix_hole([SINGLE / 2, PLANK_LOWER_SPACE + 4 * SINGLE + PLANK_UPPER_SPACE / 2, 0]);
        }
    }
}


// switch_plank_simple([0,0,0]);


module switch_plank_long_bottom(position) {
    PLANK_UPPER_SPACE = SINGLE;
    PLANK_LOWER_SPACE = SINGLE;

    translate(position) {
        difference() {
            square([SINGLE, PLANK_LOWER_SPACE + QUARTER + 3 * SINGLE + PLANK_UPPER_SPACE]);
            translate([0, PLANK_LOWER_SPACE, 0]) {
                switch_hole([0, (QUARTER - SINGLE) / 2]);
                switch_hole([0, QUARTER]);
                switch_hole([0, QUARTER + SINGLE]);
                switch_hole([0, QUARTER + 2 * SINGLE]);
            }
            fix_hole([SINGLE / 2, PLANK_LOWER_SPACE / 2, 0]);
            fix_hole([SINGLE / 2, PLANK_LOWER_SPACE + QUARTER + 3 * SINGLE + PLANK_UPPER_SPACE / 2, 0]);
        }
    }
}


// switch_plank_outer([0,0,0]);
//switch_plank_long_bottom([0,0]);
switch_hole([0,0,0]);
