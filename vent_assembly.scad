
// *************************************************************
//
// Shows the two parts positioned next to each other to visualize the assembly
// 
// Use "vent_right.scad" and "vent_left.scad" to print the individual parts
//
// *************************************************************

use <vent_right.scad>
use <vent_left.scad>

vent_right();

translate( [ -20, 0, 0 ] )
vent_left();



