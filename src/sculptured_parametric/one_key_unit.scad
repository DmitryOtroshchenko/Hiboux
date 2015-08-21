// This module contains geometric modules used for constructing keyboard
// matrix. It provides 3 main functions:
//
// ku_key generates a keycap.
// ku_hole generates a hole spanning from the corresponding keycap downwards.
// ku_support generates plastic support under the keycap.
//
// All these functions take the same set of parameters so that passing
// the same set of parameters' values generated a complete key unit
// consisting of a keycap, a support under it and a hole that should be
// substructed from the support.
//
// NB! This module MUST be synchronized with KeyUnit class in the python
// script that generates keyboard matrices. KeyUnit is a representation
// of geometries from this module so if they loose synchronisation it means
// that python code does not know what it actually generates. Thus
// weird geometric issues -> check sync.

include <../common.scad>;


module ku_key(pos, angle, height, width_multiplier, offset_x, only_trace=false) {
    //
    // Create a key unit with.
    //
    // pos - position of the keycap's close-bottom edge.
    // angle - tilt angle of the keycap.
    // height - height of the keycap's close-bottom edge over X0Y.
    // width_multiplier - how wide is the keycap relative to SINGLE?
    // offset_x - an offset along the X axis after the keycap.
    //
    // only_trace - this parameter is unique for ku_key(). It creates
    //      an infinitely thin cube that repeats the contour of the bottom
    //      face of the keycap. This parameter is used to create an
    //      idealized keycap's projections on X0Y.
    //
    translate([pos[0], pos[1], height]) {
        // Tilt the keycap.
        scale([1, width_multiplier, 1]) rotate(angle, [0, 1, 0]) {
            // Create a single keycap in [0, 0, 0].
            color("FireBrick") if (only_trace) {
                // only_trace creates and infinitely thin cube that permits
                // to create an idealized projection of the keycap's bottom
                // on the underlying plane.
                cube([KEY_WIDTH, KEY_WIDTH, 0.01]);
            }
            else {
                // The used keycap model is lifted over XOY by 1mm
                // and centered on [0, 0]. We need to pull it down
                // and to move its close-right angle to [0, 0].
                KEYCAP_OFFSET = -1;
                translate([KEY_WIDTH / 2, KEY_WIDTH / 2, KEYCAP_OFFSET]) {
                    import("../keycaps/mx_dsa.stl");
                }
            }
        }
    }
}

module ku_hole(pos, angle, height, width_multiplier, offset_x) {
    //
    // Create a hole for a single key unit.
    // Signature is identical to ku_key.
    //
    translate([pos[0], pos[1], height]) {
        // Tilt the key hole.
        rotate(angle, [0, 1, 0]) {
            // Create a key hole starting right under the keycap.
            hole_depth = 100;
            translate([0, (width_multiplier - 1) * SINGLE / 2, -hole_depth]) {
                color("green") linear_extrude(hole_depth) switch_hole([0, 0]);
            }
        }
    }
}

module ku_support(pos, angle, height, width_multiplier, offset_x) {
    //
    // Create a support for a single key unit.
    // The support covers only the zone directly under the keycap.
    // Signature is identical to ku_key.
    //
    difference() {
        // This vertical well forms the support.
        linear_extrude(height + SINGLE) {
            offset(delta=offset_x + 0.01)
            projection() {
                ku_key(pos, angle, height, width_multiplier, offset_x, only_trace=true);
            }
        }
        // The plane that limits the key support from its top.
        translate([pos[0] - 1, pos[1] - 1, height - KEYCAP_TO_PLATE_OFFSET]) {
            // Tilt the key support.
            rotate(angle, [0, 1, 0]) {
                color("blue") translate([0, 0, 50]) {
                    cube([100, 100, 100], center=true);
                }
            }
        }
        // TODO: make the support wider in order to make lined supports
        // connect nicely with each other.
        // The planes that limit the key support from its left and right.
        translate([pos[0] - 50, pos[1], -50]) {
            translate([0, -100, 0]) cube([100, 100, 100]);
            translate([0, width_multiplier * SINGLE, 0]) cube([100, 100, 100]);
        }
    }
}
