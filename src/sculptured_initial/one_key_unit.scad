
include <../common.scad>;
include <../keycaps/dsa.scad>;

USE_SIMPLIFIED_KEYS = false;


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
                key(0, 0, SINGLE);
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

module ku(pos, angle, height, with_keycap=true) {
    if (with_keycap) {
        ku_key(pos, angle, height);
    }

    difference() {
        ku_support(pos, angle, height);
        ku_hole(pos, angle, height);
    }
}

module support(pos, depth, height) {
    translate([pos[0], pos[1]]) {
        color("brown") cube([depth, SINGLE, height]);
    }
}

//support([-15, 0], 15, 40);
//ku([0,0,0], 45, 40);
//ku([KEY_WIDTH * cos(45), 0, 0], 15, 40 - KEY_WIDTH * cos(45));
//ku([KEY_WIDTH * cos(45) + KEY_WIDTH * cos(15), 0, 0], 0, 40 - KEY_WIDTH * sin(45) - KEY_WIDTH * sin(15));
//ku([KEY_WIDTH * cos(45) + KEY_WIDTH * cos(15) + KEY_WIDTH * cos(0), 0, 0], -15, 40 - KEY_WIDTH * sin(45) - KEY_WIDTH * sin(15) - KEY_WIDTH * sin(0));
//ku([KEY_WIDTH * cos(45) + KEY_WIDTH * cos(15) + KEY_WIDTH * cos(0) + KEY_WIDTH * cos(-15), 0, 0], -45, 40 - KEY_WIDTH * sin(45) - KEY_WIDTH * sin(15) - KEY_WIDTH * sin(0) - KEY_WIDTH * sin(-15));

//ku([0, 0], 45.0, 40.0);
//ku([13.0107647738, 0.0], 15.0, 26.9892352262);
//ku([30.7837999776, 0.0], 0.0, 22.2269647963);
//ku([49.1837999776, 0.0], -15.0, 22.2269647963);
//ku([66.9568351813, 0.0], -45.0, 26.9892352262);

difference() {
    union() {
        ku_support([0, 0], 45.0, 40.0);
        ku_support([13.0107647738, 0.0], 15.0, 26.9892352262);
        ku_support([30.7837999776, 0.0], 0.0, 22.2269647963);
        ku_support([49.1837999776, 0.0], -15.0, 22.2269647963);
        ku_support([66.9568351813, 0.0], -45.0, 26.9892352262);
    }
    union() {
        ku_hole([0, 0], 45.0, 40.0);
        ku_hole([13.0107647738, 0.0], 15.0, 26.9892352262);
        ku_hole([30.7837999776, 0.0], 0.0, 22.2269647963);
        ku_hole([49.1837999776, 0.0], -15.0, 22.2269647963);
        ku_hole([66.9568351813, 0.0], -45.0, 26.9892352262);
    }
}
union() {
    ku_key([0, 0], 45.0, 40.0);
    ku_key([13.0107647738, 0.0], 15.0, 26.9892352262);
    ku_key([30.7837999776, 0.0], 0.0, 22.2269647963);
    ku_key([49.1837999776, 0.0], -15.0, 22.2269647963);
    ku_key([66.9568351813, 0.0], -45.0, 26.9892352262);
}