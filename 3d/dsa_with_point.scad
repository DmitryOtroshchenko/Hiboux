translate([0, 0, -1]) import("./keycaps/mx_dsa.stl");

D = 0.8;
translate([-3, 0, 7]) rotate(90, [1, 0, 0]) 
{
    translate([0, 0, 1.5]) sphere(d=D, $fn=50, center=true);
    cylinder(h=3, d=D, $fn=20, center=true);
    translate([0, 0, -1.5]) sphere(d=D, $fn=50, center=true);
}