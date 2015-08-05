
include <common.scad>;


KEY_NARROW = 12.7;
KEY_HEIGHT = 7.4;


module key_base(type, width, is_simplified=false) {
    if (type == 0) {
        //resize([KEY_WIDTH, KEY_WIDTH * width / SINGLE, KEY_HEIGHT])
        {
            KEYCAP_OFFSET = -1;
            if (is_simplified) {
                WN_OFFSET = (KEY_WIDTH - KEY_NARROW) / 2;
                translate([WN_OFFSET, WN_OFFSET, 0]) {
                    cube([KEY_NARROW, KEY_NARROW, KEY_HEIGHT]);
                }
            }
            else {
                translate([KEY_WIDTH / 2, KEY_WIDTH / 2, KEYCAP_OFFSET]) {
                    import("./keycaps/mx_dsa.stl");
                }
            }
        }
    } else if (type == 1) {
        CASE_EXTRUSION_DEPTH = 200;
        CASE_OFFSET = 6.7;
        translate([-KEY_WIDTH, -0.1, -CASE_EXTRUSION_DEPTH - CASE_OFFSET]) {
            cube([4 * KEY_WIDTH, width + 0.2, CASE_EXTRUSION_DEPTH]);
        }
    } else if (type == 2){
        translate([0, (width - SINGLE) / 2, 0]) {
            HOLE_WIDTH = 13.97 - 0.1;
            HOLE_OFFSET = (KEY_WIDTH - HOLE_WIDTH) / 2;
            HOLE_HEIGHT = 40;
            translate([HOLE_OFFSET, HOLE_OFFSET, -HOLE_HEIGHT + 1]) {
                cube([HOLE_WIDTH, HOLE_WIDTH, HOLE_HEIGHT]);
            }
        }
    }
}


module key(angle, type, width) {
    rotate(angle, [0, 1, 0]) key_base(type, width);
}


module column(type, angles, offsets_x, offsets_z, width=SINGLE) {
    key(angles[0], type, width);
    translate([SINGLE * cos(angles[0]) + offsets_x[0], 0, -SINGLE * sin(angles[0]) + offsets_z[0]]) {
        key(angles[1], type, width);
        translate([SINGLE * cos(angles[1]) + offsets_x[1], 0, -SINGLE * sin(angles[1]) + offsets_z[1]]) {
            key(angles[2], type, width);
            translate([SINGLE * cos(angles[2]) + offsets_x[2], 0, -SINGLE * sin(angles[2]) + offsets_z[2]]) {
                key(angles[3], type, width);
                translate([SINGLE * cos(angles[3]) + offsets_x[3], 0, -SINGLE * sin(angles[3]) + offsets_z[3]]) {
                    key(angles[4], type, width);
                }
            }
        }
    }
}


//mirror([0, 1, 0]) {
module keyboard_old(with_keys=false) {
    angles = [
        [50, 30, 0, -30, -65],
        [50, 30, 0, -30, -65],
        [50, 30, 0, -20, -55],
        [50, 30, 0, -30, -65],
        [50, 30, 0, -40, -70],
        [50, 30, 0, -40, -70]
    ];
    offsets_x = [0.5, 1, 1, 0.5];
    offsets_z = [-0.5, 0, 0, 0.5];

    translate([0, 0, 0]) {
        translate([-10, -3, -7]) cube([5, 126.7, 9]);
        difference() {
            intersection() {
                translate([-10, -3, -40]) cube([100, 130, 45]);
                union() {
                    for (i = [0:4]) {
                        translate([0, SINGLE * i, 0]) column(1, angles[i], offsets_x, offsets_z);
                    }
                    translate([0, SINGLE * 5, 0]) column(1, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF);
                    translate([0, -3, 0]) column(1, angles[0], offsets_x, offsets_z);
                }
            }
            union() {
                for (i = [0:4]) {
                    translate([0, SINGLE * i, 0]) column(2, angles[i], offsets_x, offsets_z);
                }
                translate([0, SINGLE * 5, 0]) column(2, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF);
            }
        }

        if (with_keys) {
            for (i = [0:4]) {
                translate([0, SINGLE * i, 0]) column(0, angles[i], offsets_x, offsets_z);
            }
            translate([0, SINGLE * 5, 0]) column(0, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF);
        }
    }
}


keyboard_old(true);
