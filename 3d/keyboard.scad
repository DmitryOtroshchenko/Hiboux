
KW = 18;
KSPACE = 19;
KH = 10;

module key_base(type) {
    if (type == 0) {
        KEYCAP_OFFSET = -1;
        // translate([0, 0, KEYCAP_OFFSET]) cube([KW, KW, KH - KEYCAP_OFFSET]);
        translate([KW / 2, KW / 2, KEYCAP_OFFSET]) {
            import("./keycaps/mx_dsa.stl");
        }
    } else if (type == 1) {
        CASE_EXTRUSION_DEPTH = 200;
        translate([-KW, 0, -CASE_EXTRUSION_DEPTH]) {
            cube([4 * KW, KSPACE, CASE_EXTRUSION_DEPTH]);
        }
    } else if (type == 2){
        HOLE_WIDTH = 14;
        HOLE_OFFSET = (KW - HOLE_WIDTH) / 2;
        HOLE_HEIGHT = 40;
        translate([HOLE_OFFSET, HOLE_OFFSET, -HOLE_HEIGHT + 1]) {
            cube([HOLE_WIDTH, HOLE_WIDTH, HOLE_HEIGHT]);
        }
    }
}


module key(angle, type) {
    rotate(angle, [0, 1, 0]) key_base(type);
}


module column(type) {
    key(70, type);
    translate([1, 0, -1]) {
        translate([KW * cos(70), 0, -KW * sin(70)]) {
            key(30, type);
            translate([1.5, 0, 0]) {
                translate([KW * cos(30), 0, -KW * sin(30)]) {
                    key(0, type);
                    translate([1.5, 0, 0]) {
                        translate([KW, 0, 0]) {
                            key(-30, type);
                            translate([1, 0, 1]) {
                                translate([KW * cos(30), 0, KW * sin(30)]) {
                                    key(-60, type);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


translate([20, 0, -20]) cube([10, 10, 20]);
translate([0, 0, 0]) {
    difference() {
        intersection() {
            translate([-5, 0, -32]) cube([80, 120, 35]);
            for (i = [0:5]) {
                translate([0, KSPACE * i, 0]) column(1);
            }
        }
        for (i = [0:5]) {
            translate([0, KSPACE * i, 0]) column(2);
        }
    }

    for (i = [0:5]) {
        translate([0, KSPACE * i, 0]) column(0);
    }
}
