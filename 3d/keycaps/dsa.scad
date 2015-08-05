
include <../common.scad>


KEY_NARROW = 12.7;
KEY_HEIGHT = 7.4;


module key_base(type, width, is_simplified=true) {
    if (type == 0) {
        // TODO: comment and clean.
        //resize([KEY_WIDTH, KEY_WIDTH * width / SINGLE, KEY_HEIGHT])
        {
            if (is_simplified) {
                WN_OFFSET = (KEY_WIDTH - KEY_NARROW) / 2;
                translate([WN_OFFSET, WN_OFFSET, 0]) {
                    // cube([KEY_NARROW, KEY_NARROW, KEY_HEIGHT]);
                    polyhedron(
                        points=[
                            [0, 0, 0],
                            [KEY_WIDTH, 0, 0],
                            [KEY_WIDTH, KEY_WIDTH, 0],
                            [0, KEY_WIDTH, 0],
                            [WN_OFFSET, WN_OFFSET, KEY_HEIGHT],
                            [WN_OFFSET + KEY_NARROW, WN_OFFSET, KEY_HEIGHT],
                            [WN_OFFSET + KEY_NARROW, WN_OFFSET + KEY_NARROW, KEY_HEIGHT],
                            [WN_OFFSET, WN_OFFSET + KEY_NARROW, KEY_HEIGHT],
                        ],
                        faces=[
                            [0,1,2],
                            [2, 3, 0],
                            [5, 4, 6],
                            [6, 4, 7],
                            [0, 4, 1],
                            [4, 5, 1],
                            [1, 5, 2],
                            [5, 6, 2],
                            [2, 6, 3],
                            [6, 7, 3],
                            [3, 7, 0],
                            [7, 4, 0]
                        ]
                    );
                }
            }
            else {
                KEYCAP_OFFSET = -1;
                translate([KEY_WIDTH / 2, KEY_WIDTH / 2, KEYCAP_OFFSET]) {
                    import("./keycaps/mx_dsa.stl");
                }
            }
        }
    } else if (type == 1) {
        // We use a hack for 3D cases construction: each key leaves a block
        // just behind itself that formes a support for it. The union
        // of blocks for keys can be than intersected with a cube in order
        // to shape the case block.
        CASE_EXTRUSION_DEPTH = 200;
        // TODO: comment and clean.
        translate([-KEY_WIDTH, -0.1, -CASE_EXTRUSION_DEPTH - KEYCAP_TO_PLATE_OFFSET]) {
            cube([4 * KEY_WIDTH, width + 0.2, CASE_EXTRUSION_DEPTH]);
        }
    } else if (type == 2) {
        // If key is bigger than single, the additional key size should be
        // split in two and added to the left and to the right of the hole.
        // This code works correctly only with horizontal keys.
        translate([0, (width - SINGLE) / 2, 0]) {
            // The standard offset between a single keycap contour and the
            // corresponding hole.
            HOLE_OFFSET = (KEY_WIDTH - HOLE_SIZE) / 2;
            // How deep the hole should be cut? It may be necessary
            // to increase this parameter for more bulky keyboard cases.
            HOLE_HEIGHT = 40;
            // We move the hole by 1 mm above the requested position in order
            // to avoid non noded geometries intersections.
            translate([HOLE_OFFSET, HOLE_OFFSET, -HOLE_HEIGHT + 1]) {
                cube([HOLE_SIZE, HOLE_SIZE, HOLE_HEIGHT]);
            }
        }
    }
}


module key(angle, type, width) {
    rotate(angle, [0, 1, 0]) key_base(type, width);
}
