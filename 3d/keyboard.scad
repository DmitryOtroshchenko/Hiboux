
include <common.scad>;
include <keycaps/dsa.scad>;
include <column.scad>;


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
                        translate([0, SINGLE * i, 0]) column5(1, angles[i], offsets_x, offsets_z);
                    }
                    translate([0, SINGLE * 5, 0]) column5(1, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF);
                    translate([0, -3, 0]) column5(1, angles[0], offsets_x, offsets_z);
                }
            }
            union() {
                for (i = [0:4]) {
                    translate([0, SINGLE * i, 0]) column5(2, angles[i], offsets_x, offsets_z);
                }
                translate([0, SINGLE * 5, 0]) column5(2, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF);
            }
        }

        if (with_keys) {
            for (i = [0:4]) {
                translate([0, SINGLE * i, 0]) column5(0, angles[i], offsets_x, offsets_z);
            }
            translate([0, SINGLE * 5, 0]) column5(0, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF);
        }
    }
}


keyboard_old(true);
