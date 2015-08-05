

KEY_WIDE = 18.4;
KW = KEY_WIDE;
KEY_NARROW = 12.7;
KEY_HEIGHT = 7.4;

SINGLE = 19;
SINGLE_AND_HALF = SINGLE * 1.5;

module key_base(type, width, is_simplified=true) {
    if (type == 0) {
        resize([KW, KW * width / SINGLE, KEY_HEIGHT])
        {
            KEYCAP_OFFSET = -1;
            if (is_simplified) {
                WN_OFFSET = (KEY_WIDE - KEY_NARROW) / 2;
                polyhedron(
                points=[
                    [0, 0, 0],
                    [KEY_WIDE, 0, 0],
                    [KEY_WIDE, KEY_WIDE, 0],
                    [0, KEY_WIDE, 0],
                    [WN_OFFSET, WN_OFFSET, KEY_HEIGHT],
                    [WN_OFFSET + KEY_NARROW, WN_OFFSET, KEY_HEIGHT],
                    [WN_OFFSET + KEY_NARROW, WN_OFFSET + KEY_NARROW, KEY_HEIGHT],
                    [WN_OFFSET, WN_OFFSET + KEY_NARROW, KEY_HEIGHT],
                ],
                faces=[
                    [0, 1, 2],
                    [2, 3, 0],
                    [4, 5, 6],
                    [6, 7, 4],
                    [0, 1, 4],
                    [4, 5, 1],
                    [1, 2, 5],
                    [5, 6, 2],
                    [2, 3, 6],
                    [6, 7, 3],
                    [3, 0, 7],
                    [7, 4, 0]
                ]
            );
            }
            else {
                translate([KW / 2, KW / 2, KEYCAP_OFFSET]) {
                    import("./keycaps/mx_dsa.stl");
                }
            }
        }
    } else if (type == 1) {
        CASE_EXTRUSION_DEPTH = 200;
        CASE_OFFSET = 6.7;
        translate([-KW, -0.1, -CASE_EXTRUSION_DEPTH - CASE_OFFSET]) {
            cube([4 * KW, width + 0.2, CASE_EXTRUSION_DEPTH]);
        }
    } else if (type == 2){
        translate([0, (width - SINGLE) / 2, 0]) {
            HOLE_WIDTH = 13.97 - 0.1;
            HOLE_OFFSET = (KW - HOLE_WIDTH) / 2;
            HOLE_HEIGHT = 60;
            translate([HOLE_OFFSET, HOLE_OFFSET, -HOLE_HEIGHT + 1]) {
                cube([HOLE_WIDTH, HOLE_WIDTH, HOLE_HEIGHT]);
            }
        }
    }
}


module key(angle, type, width) {
    rotate(angle, [0, 1, 0]) key_base(type, width);
}


module column(type, angles, offsets_x, offsets_z, width=SINGLE, with_last=true) {
    key(angles[0], type, width);
    translate([SINGLE * cos(angles[0]) + offsets_x[0], 0, -SINGLE * sin(angles[0]) + offsets_z[0]]) {
        key(angles[1], type, width);
        translate([SINGLE * cos(angles[1]) + offsets_x[1], 0, -SINGLE * sin(angles[1]) + offsets_z[1]]) {
            key(angles[2], type, width);
            translate([SINGLE * cos(angles[2]) + offsets_x[2], 0, -SINGLE * sin(angles[2]) + offsets_z[2]]) {
                key(angles[3], type, width);
                if (with_last) {
                    translate([SINGLE * cos(angles[3]) + offsets_x[3], 0, -SINGLE * sin(angles[3]) + offsets_z[3]]) {
                        key(angles[4], type, width);
                    }
                }
            }
        }
    }
}


module keyboard(with_keys=false) {
    angles = [
        [50, 30, 0, -30, -65],
        [50, 30, 0, -30, -65],
        [50, 30, 0, -25, -55],
        [50, 30, 0, -30, -65],
        [50, 20, -15, -50, -70],
        [50, 20, -15, -50, -70]
    ];
    offsets_x = [0.5, 1, 1, 0.5];
    offsets_z = [-0.5, 0, 0, 0.5];

    translate([0, 0, 0]) {
        translate([-10, -3, -7]) cube([5, 126.7, 9]);
        difference() {
            intersection() {
                translate([-10, -3, -40]) cube([100, 130, 45]);
                union() {
                    for (i = [0:4]) {
                        translate([0, SINGLE * i, 0]) column(1, angles[i], offsets_x, offsets_z);
                    }
                    translate([0, SINGLE * 5, 0]) column(1, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF);
                    translate([0, -3, 0]) column(1, angles[0], offsets_x, offsets_z);
                }
            }
            union() {
                for (i = [0:3]) {
                    translate([0, SINGLE * i, 0]) column(2, angles[i], offsets_x, offsets_z);
                }
                translate([0, SINGLE * 4, 0]) column(2, angles[4], offsets_x, offsets_z, SINGLE, false);
                translate([0, SINGLE * 5, 0]) column(2, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF, false);
            }
        }

        if (with_keys) {
            for (i = [0:3]) {
                translate([0, SINGLE * i, 0]) column(0, angles[i], offsets_x, offsets_z);
            }
            translate([0, SINGLE * 4, 0]) column(0, angles[4], offsets_x, offsets_z, SINGLE, false);
            translate([0, SINGLE * 5, 0]) column(0, angles[5], offsets_x, offsets_z, SINGLE_AND_HALF, false);
        }
    }
}


keyboard(false);