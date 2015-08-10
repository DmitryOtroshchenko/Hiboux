
include <../common.scad>;
include <../keycaps/dsa.scad>;

USE_SIMPLIFIED_KEYS = false;

module key_unit_impl(angle, key_well_depth) {
    angle = abs(angle);
    rotation_axis = [0, 1, 0];

    translate([0, 0, key_well_depth]) rotate(angle, rotation_axis) {
        color("FireBrick") translate([0, 0, KEYCAP_TO_PLATE_OFFSET]) key(0, 0, SINGLE);

        difference() {
            translate() {
                rotate(-angle, rotation_axis) {
                    translate([0, 0, -key_well_depth]) {
                        cube([SINGLE * cos(angle) + KEYCAP_TO_PLATE_OFFSET * sin(angle), SINGLE, key_well_depth]);
                    }
                }
            }
            translate([-50, -50, 0]) cube([100, 100, 100]);
            color("YellowGreen") translate([0, 0, -100]) linear_extrude(200) switch_hole([0, 0]);
        }
    }
}

module key_unit(position, angle, key_well_depth) {
    translate(position) {
        if (angle >= 0) {
            key_unit_impl(angle, key_well_depth);
        }
        else {
            translate([SINGLE * cos(abs(angle)) + KEYCAP_TO_PLATE_OFFSET * sin(abs(angle)), 0, 0]) {
                mirror([1, 0, 0]) key_unit_impl(angle, key_well_depth);
            }
        }
    }
}

// key_unit([0,0,0], -30, 40);
