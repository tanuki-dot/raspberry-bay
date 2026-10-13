use <novvvy.scad>;
$fn = 48;

difference() {
    union() {
        bay();                             
        // translate([0, 20, 10]) cube([10, 10, 5], center=true);
    }

    // translate([30, 0, 5]) cylinder(h=20, d=4, center=true);
}
