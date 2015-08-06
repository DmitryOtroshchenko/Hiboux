

module spacer_stand_hole(outer_diameter, spacer_height) {
    // TODO: explain.
    outer_radius = outer_diameter / 2;
    triangle_side = 2 * outer_radius / sqrt(3);
    linear_extrude(spacer_height) minkowski() {
        polygon(
            points=[
                [-outer_radius, -triangle_side / 2],
                [-outer_radius, triangle_side / 2],
                [0, triangle_side],
                [outer_radius, triangle_side / 2],
                [outer_radius, -triangle_side / 2],
                [0, -triangle_side]
            ],
            paths=[ [0, 1, 2, 3, 4, 5] ]
        );
        circle(1, $fn=30);
    }
}


module stand_bar(length, thickness, max_height) {
    cube([thickness, length, max_height]);
}


module connector_bar(width, thickness, max_height) {
    cube([width, thickness, max_height]);
}


module keyboard_stand(length, width, thickness, angle, stand_wall_thickness=5, spacer_diameter=6) {
    max_height = 30;
    spacer_holder_size = spacer_diameter + 2 * stand_wall_thickness;
    difference() {
        difference() {
            union() {
                stand_bar(length, thickness, max_height);
                cube([spacer_holder_size, spacer_holder_size, max_height]);
                translate([width - thickness, 0, 0]) stand_bar(length, thickness, max_height);
                translate([width - spacer_holder_size, 0, 0]) cube([spacer_holder_size, spacer_holder_size, max_height]);
                connector_bar(width, thickness, max_height);
            }
            translate([spacer_holder_size / 2, spacer_holder_size / 2, -max_height]) spacer_stand_hole(spacer_diameter, 3 * max_height);
            translate([width - spacer_holder_size / 2, spacer_holder_size / 2, -max_height]) spacer_stand_hole(spacer_diameter, 3 * max_height);
        }
        translate([-10, -10, max_height]) rotate(-angle, [1, 0, 0]) cube([width + 20, length + 20, 100]);
    }
}


keyboard_stand(50, 100, 10, 20, 5);
