
include <../common.scad>


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


module keyboard_half(position) {
    COLUMN_OFFSETS = [0, 0, 7, 13, 10, 10, 10];

    translate(position) {
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
}


module thumb_cluster_horizontal_simple(position) {
    OFFSET = SINGLE;
    translate(position) {
        difference() {
            square([
                OFFSET + 4 * SINGLE + OFFSET,
                OFFSET + SINGLE + SINGLE_AND_HALF + OFFSET
            ]);
            translate([OFFSET, OFFSET, 0]) {
                switch_hole([0 * SINGLE, SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, 0]);
                switch_hole([1 * SINGLE, SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, 0]);
                switch_hole([2 * SINGLE, SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, 0]);
                switch_hole([3 * SINGLE, 0, 0]);
                switch_hole([3 * SINGLE, SINGLE, 0]);
            }
        }
    }
}


module thumb_cluster_horizontal(position) {
    OFFSET_X = 7;
    OFFSET_Y = SINGLE;

    translate(position) {
        difference() {
            square([
                OFFSET_X + 4 * SINGLE + OFFSET_X,
                OFFSET_Y + SINGLE + SINGLE_AND_HALF + OFFSET_Y
            ]);
            translate([OFFSET_X, OFFSET_Y, 0]) {
                switch_hole([0 * SINGLE, (SINGLE_AND_HALF - SINGLE) / 2, 0], true);
                switch_hole([1 * SINGLE, (SINGLE_AND_HALF - SINGLE) / 2, 0], true);
                switch_hole([2 * SINGLE, (SINGLE_AND_HALF - SINGLE) / 2, 0], true);
                switch_hole([3 * SINGLE, 0, 0]);
                switch_hole([3 * SINGLE, SINGLE, 0]);
            }
        }
    }
}


module thumb_cluster_vertical(position) {
    OFFSET = SINGLE;
    translate(position) {
        difference() {
            square([
                OFFSET + SINGLE + SINGLE_AND_HALF + 5,
                SINGLE + SINGLE + SINGLE_AND_HALF + SINGLE//OFFSET + 2 * SINGLE + OFFSET
            ]);
            translate([OFFSET, OFFSET, 0]) {
                switch_hole([0, 0, 0], true);
                switch_hole([SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, 0, 0]);
                switch_hole([SINGLE + (SINGLE_AND_HALF - SINGLE) / 2, SINGLE, 0]);
            }
        }
    }
}


module keyboard_plate() {
    PLATE_OFFSET = 10;
    HAND_REST_HEIGHT = 110;

    difference() {
        square([
            PLATE_OFFSET + SINGLE_AND_HALF + 6 * SINGLE + PLATE_OFFSET,
            HAND_REST_HEIGHT + 13 + 4 * SINGLE + PLATE_OFFSET
        ]);
        keyboard_half([PLATE_OFFSET, HAND_REST_HEIGHT, 0]);
    }

    // Compute keyboard half width.
    echo(SINGLE * 6 + SINGLE_AND_HALF + 2 * PLATE_OFFSET);
    // Compute keyboard half height.
    echo(HAND_REST_HEIGHT + 13 + 4 * SINGLE + PLATE_OFFSET);
}


OFFSET = 5;

translate([OFFSET, OFFSET]) {
    // Left keyboard half.
    keyboard_plate();

    translate([0, 210]) {
        // Right keyboard half (mirrored).
        translate([162.5, 0]) mirror([1, 0]) keyboard_plate();

        // Thumb clusters.
        translate([0, 210]) {
            thumb_cluster_vertical([0, 0]);
            thumb_cluster_horizontal([SINGLE + SINGLE_AND_HALF + 25, 0]);

            translate([0, SINGLE + SINGLE + SINGLE_AND_HALF + SINGLE + 1]) {
                thumb_cluster_vertical([0, 0]);
                thumb_cluster_horizontal([SINGLE + SINGLE_AND_HALF + 25, 0]);
            }
        }
    }
}

// Right guide.
//translate([170, 0, 0]) square([5, 600]);
//translate([0, 600, 0]) square([170, 5]);
