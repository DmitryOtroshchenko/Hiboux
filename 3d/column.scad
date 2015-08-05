
include <common.scad>;


module column_var_size(type, angles, offsets_x, offsets_z, width, enabled) {
    if (enabled[0]) {
        key(angles[0], type, width);
        if (enabled[1]) translate([SINGLE * cos(angles[0]) + offsets_x[0], 0, -SINGLE * sin(angles[0]) + offsets_z[0]]) {
            key(angles[1], type, width);
            if (enabled[2]) translate([SINGLE * cos(angles[1]) + offsets_x[1], 0, -SINGLE * sin(angles[1]) + offsets_z[1]]) {
                key(angles[2], type, width);
                if (enabled[3]) translate([SINGLE * cos(angles[2]) + offsets_x[2], 0, -SINGLE * sin(angles[2]) + offsets_z[2]]) {
                    key(angles[3], type, width);
                    if (enabled[4]) translate([SINGLE * cos(angles[3]) + offsets_x[3], 0, -SINGLE * sin(angles[3]) + offsets_z[3]]) {
                        key(angles[4], type, width);
                    }
                }
            }
        }
    }
}


module column5(type, angles, offsets_x, offsets_z, width=SINGLE) {
    column_var_size(type, angles, offsets_x, offsets_z, width, [true, true, true, true, true]);
}


module column4(type, angles, offsets_x, offsets_z, width=SINGLE) {
    column_var_size(type, angles, offsets_x, offsets_z, width, [true, true, true, true, false]);
}


module column3(type, angles, offsets_x, offsets_z, width=SINGLE) {
    column_var_size(type, angles, offsets_x, offsets_z, width, [true, true, true, false, false]);
}
