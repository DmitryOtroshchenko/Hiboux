

//translate([-19 - 3 - 11, 0, 34]) rotate(70, [0,1,0]) cube([18,18,10]);
//translate([-19 - 3, 0, 10.5]) rotate(30, [0,1,0]) cube([18,18,10]);
//cube([18, 18, 10]);
//translate([19 + 5, 0, 1.5]) rotate(-30, [0,1,0]) cube([18,18,10]);


KW = 18;
KSPACE = 19;
KH = 10;

HOLE_WIDTH = 14;
HOLE_HEIGHT = 40;
HOLE_OFFSET = (KW - HOLE_WIDTH) / 2;

module key_base(type) {
    if (type == 0) {
        translate([0, 0, 2]) cube([KW, KW, KH - 2]);
    } else if (type == 1) {
        translate([-KW, 0, -200]) cube([KW*4, KW+2, 200]);
    } else if (type == 2){
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

translate([0, 0, -10]) {
    difference() {
        intersection() {
            translate([-25, 0, -30]) cube([110, 120, 50]);
            for (i = [0:5]) {
                translate([0, KSPACE * i, 0]) column(1);
            }
        }
        for (i = [0:5]) {
            translate([0, KSPACE * i, 0]) column(2);
        }
    }

    for (i = [0:5]) {
        //translate([0, KSPACE * i, 0]) column(0);
    }
}