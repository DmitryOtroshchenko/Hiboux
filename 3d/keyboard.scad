
include <common.scad>;
include <keycaps/dsa.scad>;


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
