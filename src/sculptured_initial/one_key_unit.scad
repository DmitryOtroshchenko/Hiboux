
include <../common.scad>;
include <../keycaps/dsa.scad>;

USE_SIMPLIFIED_KEYS = false;

module key_unit(angle, key_well_depth) {
    angle = abs(angle);
    rotation_axis = [0, 1, 0];

    translate([0, 0, key_well_depth]) rotate(angle, rotation_axis) {
        //color("FireBrick") translate([0, 0, 1]) key(0, 0, SINGLE);
        offset_x = (SINGLE - 14) / 2;
        offset_y = (SINGLE - 16) / 2;
        translate([offset_x, offset_y, 6]) cube([14, 16, 5]);

        difference() {
            translate() {
                rotate(-angle, rotation_axis) {
                    translate([0, 0, -key_well_depth]) cube([SINGLE * cos(angle), SINGLE, key_well_depth]);
                }
            }
            translate([-50, -50, 0]) cube([100, 100, 100]);
            color("YellowGreen") translate([0, 0, -100]) linear_extrude(200) switch_hole([0, 0]);
        }
    }
}
key_unit(35, 25);
translate([15.5, 0, -11.5]) key_unit(15, 25);