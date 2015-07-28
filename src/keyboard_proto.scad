
SINGLE = 19;
SINGLE_AND_HALF = 1.5 * SINGLE;
DOUBLE = 2 * SINGLE;


module switch_hole(position) {
    // Cherry MX switch hole with the center at `position`. Sizes come
    // from the ErgoDox design.

    SWITCH_HOLE_SIZE = 13.97;
    SWITCH_OFFSET = (SINGLE - SWITCH_HOLE_SIZE) / 2;

    position = [
        position[0] + SWITCH_OFFSET,
        position[1] + SWITCH_OFFSET
    ];

    hole_size = SWITCH_HOLE_SIZE;
    translate(position) {
        square([hole_size, hole_size]);
    }
};


module switch_plank_outer(position, use_double=false) {
    translate(position) {
        if (use_double) {
            switch_hole([
                SINGLE_AND_HALF - SINGLE,
                (DOUBLE - SINGLE) / 2
            ]);
        } else {
            switch_hole([
                SINGLE_AND_HALF - SINGLE,
                (DOUBLE - SINGLE_AND_HALF) + (SINGLE_AND_HALF - SINGLE) / 2
            ]);
        }
        switch_hole([(SINGLE_AND_HALF - SINGLE) / 2, DOUBLE]);
        switch_hole([(SINGLE_AND_HALF - SINGLE) / 2, DOUBLE + SINGLE]);
    }
}


module switch_plank_simple(position) {
    translate(position) {
        switch_hole([0, 0 * SINGLE]);
        switch_hole([0, 1 * SINGLE]);
        switch_hole([0, 2 * SINGLE]);
        switch_hole([0, 3 * SINGLE]);
    }
}


module switch_plank_inner(position) {
    translate(position) {
        switch_hole([0, (DOUBLE - SINGLE) / 2]);
        switch_hole([0, DOUBLE + (DOUBLE - SINGLE) / 2]);
    }
}


// switch_hole([0,0,0]);
// switch_plank_simple([0,0,0]);
// switch_plank_outer([0,0,0], false);
// switch_plank_inner([0,0,0]);
// translate([0,0,-4]) { square([SINGLE, DOUBLE]); }
// translate([0,DOUBLE,-4]) { square([SINGLE_AND_HALF, SINGLE]); }


module keyboard_half(position) {
    COLUMN_OFFSETS = [0, 0, 7, 13, 10, 10, 10];

    switch_plank_outer([0, COLUMN_OFFSETS[0], 0], false);
    for (n_row = [0:4]) {
        switch_plank_simple([
            SINGLE_AND_HALF + n_row * SINGLE,
            COLUMN_OFFSETS[n_row + 1], 0
        ]);
    }
    switch_plank_inner([
        SINGLE_AND_HALF + 5 * SINGLE,
        COLUMN_OFFSETS[6], 0
    ]);
}

// keyboard_half([0, 0, 0]);


module thumb_cluster_horizontal(position) {
    translate(position) {
        switch_hole([0 * SINGLE, SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, 0]);
        switch_hole([1 * SINGLE, SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, 0]);
        switch_hole([2 * SINGLE, SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, 0]);
        switch_hole([3 * SINGLE, 0, 0]);
        switch_hole([3 * SINGLE, SINGLE, 0]);
    }
}

thumb_cluster_horizontal([0,0,0]);
