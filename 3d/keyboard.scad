
KW = 18;
SINGLE = 19;
KH = 10;

module key_base(type) {
    if (type == 0) {
        KEYCAP_OFFSET = -1;
        translate([KW / 2, KW / 2, KEYCAP_OFFSET]) {
            import("./keycaps/mx_dsa.stl");
        }
    } else if (type == 1) {
        CASE_EXTRUSION_DEPTH = 200;
        CASE_OFFSET = 6.5;
        translate([-KW, 0, -CASE_EXTRUSION_DEPTH - CASE_OFFSET]) {
            cube([4 * KW, SINGLE, CASE_EXTRUSION_DEPTH]);
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


module column(type, angles, offsets_x, offsets_z) {
    key(angles[0], type);
    translate([SINGLE * cos(angles[0]) + offsets_x[0], 0, -SINGLE * sin(angles[0]) + offsets_z[0]]) {
        key(angles[1], type);
        translate([SINGLE * cos(angles[1]) + offsets_x[1], 0, -SINGLE * sin(angles[1]) + offsets_z[1]]) {
            key(angles[2], type);
            translate([SINGLE * cos(angles[2]) + offsets_x[2], 0, -SINGLE * sin(angles[2]) + offsets_z[2]]) {
                key(angles[3], type);
                translate([SINGLE * cos(angles[3]) + offsets_x[3], 0, -SINGLE * sin(angles[3]) + offsets_z[3]]) {
                    key(angles[4], type);
                }
            }
        }
    }
}


angles = [
    [50, 30, 0, -30, -65],
    [50, 30, 0, -30, -65],
    [50, 30, 0, -20, -55],
    [50, 30, 0, -30, -65],
    [50, 30, 0, -40, -70],
    [50, 30, 0, -40, -70]
];
offsets_x = [0.5, 1, 1, 0.5];
offsets_z = [-0.5, 0, 0, 0.5];

//translate([30, 0, -20]) cube([10, 10, 30]);
translate([0, 0, 0]) {
    difference() {
        intersection() {
            translate([-20, 0, -40]) cube([110, 120, 45]);
            for (i = [0:5]) {
                translate([0, SINGLE * i, 0]) column(1, angles[i], offsets_x, offsets_z);
            }
        }
        for (i = [0:5]) {
            translate([0, SINGLE * i, 0]) column(2, angles[i], offsets_x, offsets_z);
        }
    }

    for (i = [0:5]) {
        translate([0, SINGLE * i, 0]) column(0, angles[i], offsets_x, offsets_z);
    }
}
