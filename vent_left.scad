
// *************************************************************
//
// The left part, rotated into the correct vertial position for printing
//
// *************************************************************


include <vent_parameters.scad>
use <vent.scad>


module vent_left() {

    // The hose attachment components
    hose_attachment();
    pipe();

    // Add the interface insert
    vent_interface_insert( width  = interface_insert_width,
                           depth  = interface_insert_depth,
                           margin = -interface_insert_margin );


    // Add the bolt connector minus the right part of the bolt
    difference() {

        union() {
            bolt_connector_bottom();
            bolt_connector_top();
        }

        // translate( [ cube_subtract_size/2 - (hood_corner_curve + inside_bottom_horz - bolt_connector_depth/2 ) , 
        translate( [ cube_subtract_size/2 - (hood_corner_curve + inside_bottom_horz ), 
                    0 , 
                    0 ] )
        cube( size = cube_subtract_size, center = true );

    }

    // Add the top attachment clip to hold the parts together better
    // left_clip();

}

// Instantiate the part iself and rotate for printing
translate( [ 0, 0, hose_attachment_length + hose_attachment_stop_length ] ) 
rotate( [ 0, -90, 0 ] )
translate( [ -hose_attachment_location_x, -hose_attachment_location_y, -hose_attachment_location_z ] ) 
vent_left();





