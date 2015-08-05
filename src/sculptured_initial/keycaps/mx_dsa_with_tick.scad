
module dsa_with_tick(tick_width, tick_length)
{
    // Make the keycap stand on the ground.
    translate([0, 0, -1]) import("./mx_dsa.stl");

    KEY_HEIGHT = 7.4;
    translate([-3, 0, KEY_HEIGHT - 0.3])
    {
        rotate(90, [1, 0, 0])
        {
            translate([0, 0, tick_length / 2]) sphere(d=tick_width, $fn=50, center=true);
            cylinder(h=tick_length, d=tick_width, $fn=20, center=true);
            translate([0, 0, -tick_length / 2]) sphere(d=tick_width, $fn=50, center=true);
        }
    }
}


dsa_with_tick(0.8, 5);
