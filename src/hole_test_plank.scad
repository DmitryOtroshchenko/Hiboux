
SINGLE = 19;

module switch_hole(position, hole_size_delta) {
    // Cherry MX switch hole with the center at `position`. Sizes come
    // from the ErgoDox design.

    SWITCH_HOLE_SIZE = 13.97;
    SWITCH_OFFSET = (SINGLE - SWITCH_HOLE_SIZE) / 2;

    hole_size = SWITCH_HOLE_SIZE + hole_size_delta;
    translate(position) {
        translate([SWITCH_OFFSET, SWITCH_OFFSET, 0]) {
            square([hole_size, hole_size]);
        }
    }
};


OFFSET = 5;

translate([OFFSET, OFFSET, 0]) {
    difference() {
        square([2 * OFFSET + 7 * SINGLE, 2 * OFFSET + 2.5 * SINGLE]);
        translate([OFFSET, OFFSET, 0]) {
            for (n_button = [0:6]) {
                delta = (n_button - 3) * 0.05;
                echo(delta);
                switch_hole([SINGLE * n_button, SINGLE * 1.5], delta);
                translate([SINGLE * n_button + SINGLE / 2, 10]) {
                    rotate([0, 0, 90]) {
                        text(
                            str(delta), 
                            font="Consolas", 
                            size=5, 
                            halign="center",
                            valign="center"
                        );
                    }
                }
            }
        }
    }
}