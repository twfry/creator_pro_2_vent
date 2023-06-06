
// *************************************************************
//
// The right part to print
//
// *************************************************************


include <vent_parameters.scad>
use <vent.scad>


module vent_right() {

    // The hood attachment component
    hood_attachment();

    // The hood corner minus the interface insert
    difference() {

        hood_corner();

        // Subtract the interface insert
        vent_interface_insert( width  = interface_insert_width,
                               depth  = interface_insert_depth,
                               margin = interface_insert_margin );

    }
    

    // Add the bottom and top bolt connectors minus the left part of the bolt
    difference() {

        union() {
            bolt_connector_bottom();
            bolt_connector_top();
        }

        translate( [ -(hood_corner_curve + inside_bottom_horz ) - cube_subtract_size/2, 
                    cube_subtract_size/2 + hood_cover_total_width/2 + epsilon, 
                    0 ] )
        cube( size = cube_subtract_size, center = true );

    }

    // Add the top attachment clip to hold the parts together better
    //right_clip();

}


// Instantiate the right part to print
vent_right();






