
include <../common.scad>;


module ku_key(pos, angle, height, simplified=false) {
    //
    // Create a key unit with its close edge on <height>.
    //
    translate([pos[0], pos[1], height]) {
        // Tilt the keycap forward or back.
        rotate(angle, [0, 1, 0]) {
            // Create a single keycap in [0, 0, 0].
            color("FireBrick") if (simplified) {
                cube([KEY_WIDTH, KEY_WIDTH, 0.01]);
            }
            else {
                KEYCAP_OFFSET = -1;
                translate([KEY_WIDTH / 2, KEY_WIDTH / 2, KEYCAP_OFFSET]) {
                    import("../keycaps/mx_dsa.stl");
                }
            }
        }
    }
}

module ku_hole(pos, angle, height) {
    //
    // Create a hole for a single key unit.
    // Signature is identical to key_unit_keycap.
    //
    translate([pos[0], pos[1], height]) {
        // Tilt the key hole forward or back.
        rotate(angle, [0, 1, 0]) {
            // Create a key hole starting right under the keycap.
            hole_depth = 100;
            translate([0, 0, -hole_depth]) {
                color("green") linear_extrude(hole_depth) switch_hole([0, 0]);
            }
        }
    }
}

module ku_support(pos, angle, height) {
    //
    // Create a support for a single key unit.
    // The support covers only the zone directly under the keycap.
    // Signature is identical to key_unit_keycap.
    //
    difference() {
        // This vertical well forms the support.
        linear_extrude(height + SINGLE) projection() ku_key(pos, angle, height, true);
        // The plane that limits the key support from its top.
        translate([pos[0] - 1, pos[1] - 1, height - KEYCAP_TO_PLATE_OFFSET]) {
            // Tilt the key support forward or back.
            rotate(angle, [0, 1, 0]) {
                color("blue") translate([0, 0, 50]) cube([100, 100, 100], center=true);
            }
        }
    }
}
