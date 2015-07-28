
module test_sample() {
    translate([25, 10]) square([10, 10], center=true);

    translate([2, 10]) text(
        "TEST", 
        font="Consolas", 
        size=5, 
        halign="left ",
        valign="center"
    );
}

test_sample();
translate([30, 0]) test_sample();