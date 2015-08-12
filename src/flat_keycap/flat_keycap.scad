

keycap_size = 18;
keycap_height = 5;
keycap_thickness = 1.5;
bevel_size = 1.5;


module round_edge() {
    translate([bevel_size, bevel_size, bevel_size]) {
        sphere(r = bevel_size, $fn = 50);
        rotate(90, [0, 1, 0]) {
            cylinder(r = bevel_size, h = keycap_size - 2 * bevel_size, $fn=30);
        }
        translate([keycap_size - 2 * bevel_size, 0, 0]) sphere(r = bevel_size, $fn = 50);
    }
}


difference() {
    translate([bevel_size, bevel_size, bevel_size]) {
        minkowski() {
            flat_size = keycap_size - 2 * bevel_size;
            cube([flat_size, flat_size, keycap_height]);
            sphere(r = bevel_size, $fn=50);
        }
    }
    translate([-10, -10, keycap_height]) cube([100, 100, 100]);
    translate([keycap_thickness, keycap_thickness, keycap_thickness]) {
        milling_size = keycap_size - 2 * keycap_thickness;
        cube([milling_size, milling_size, 100]);
    }
}


module stem_round() {
    translate([keycap_size / 2, keycap_size / 2, 0.1]) {
        difference() {
            cylinder(d = 4.3 + 1, h = keycap_height - 0.1, $fn=40);
            translate([0, 0, keycap_height / 2]) {
                cube([1, 4.3, keycap_height + 2], center=true);
                rotate(90, [0, 0, 1]) cube([1, 4.3, keycap_height + 2], center=true);
            }
        }
    }
}


module stem_square() {
    translate([keycap_size / 2, keycap_size / 2, 0.1]) {
        translate([0, 0, keycap_height / 2]) {
            difference() {
                cube([5, 5, keycap_height - 0.1], center=true);
                cube([1, 7, keycap_height + 2], center=true);
                rotate(90, [0, 0, 1]) cube([1, 7, keycap_height + 2], center=true);
            }
        }
    }
}


stem_square();