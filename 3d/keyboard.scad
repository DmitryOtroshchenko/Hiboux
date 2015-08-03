

//translate([-19 - 3 - 11, 0, 34]) rotate(70, [0,1,0]) cube([18,18,10]);
//translate([-19 - 3, 0, 10.5]) rotate(30, [0,1,0]) cube([18,18,10]);
//cube([18, 18, 10]);
//translate([19 + 5, 0, 1.5]) rotate(-30, [0,1,0]) cube([18,18,10]);


KW = 18;
KSPACE = 19;
KH = 10;

module key(angle, is_far) {
    if (is_far) {
        rotate(angle, [0, 1, 0]) translate([0, 0, -KH]) cube([KW, KW, KH]);
    } else {
        rotate(angle, [0, 1, 0]) translate([-KW, 0, -KH]) cube([KW, KW, KH]);
    }
}

//key(-45, false);

module column() {
    key(80, false);
    translate([1, 0, -1]) {
        key(30, true);
        translate([1, 0, 0]) { 
            translate([KW * cos(30), 0, -KW * sin(30)]) {
                key(0, true);
                translate([1, 0, 0]) {
                    translate([KW, 0, 0]) {
                        key(-30, true);
                        translate([1, 0, 1]) {
                            translate([KW * cos(30), 0, KW * sin(30)]) {
                                key(-60, true);
                            }
                        }
                    }
                }
            }
        }
    }
}

for (i = [0:5]) {
    translate([0, KSPACE * i, 0]) column();
}