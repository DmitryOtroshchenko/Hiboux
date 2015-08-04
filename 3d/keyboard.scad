
KW = 18;
KSPACE = 19;
KH = 10;

module key_base(type) {
    if (type == 0) {
        KEYCAP_OFFSET = 2;
        //translate([0, 0, KEYCAP_OFFSET]) cube([KW, KW, KH - KEYCAP_OFFSET]);
        translate([KW/2, KW/2, KEYCAP_OFFSET]) import("./keycaps/mx_dsa.stl");
    } else if (type == 1) {
        CASE_EXTRUSION_DEPTH = 200;
        translate([-KW, 0, -CASE_EXTRUSION_DEPTH]) cube([4 * KW, KSPACE, CASE_EXTRUSION_DEPTH]);
    } else if (type == 2){
        HOLE_WIDTH = 14;
        HOLE_OFFSET = (KW - HOLE_WIDTH) / 2;
        HOLE_HEIGHT = 40;
        translate([HOLE_OFFSET, HOLE_OFFSET, -HOLE_HEIGHT + 1]) cube([HOLE_WIDTH, HOLE_WIDTH, HOLE_HEIGHT]);
    }
}


module key(angle, is_far, type) {
    if (is_far) {
        rotate(angle, [0, 1, 0]) translate([0, 0, -KH]) key_base(type);
    } else {
        rotate(angle, [0, 1, 0]) translate([-KW, 0, -KH]) key_base(type);
    }
}


module column(type) {
    key(80, false, type);
    translate([1, 0, -1]) {
        key(30, true, type);
        translate([1, 0, 0]) { 
            translate([KW * cos(30), 0, -KW * sin(30)]) {
                key(0, true, type);
                translate([1, 0, 0]) {
                    translate([KW, 0, 0]) {
                        key(-30, true, type);
                        translate([1, 0, 1]) {
                            translate([KW * cos(30), 0, KW * sin(30)]) {
                                key(-60, true, type);
                            }
                        }
                    }
                }
            }
        }
    }
}

//key_base(0);
//key_base(2);

//cube([5, 5, 100]);
translate([0, 0, -10]) {
    difference() {
        intersection() {
            translate([-20, 0, -30]) cube([100, 120, 50]);
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