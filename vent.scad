
// *************************************************************
//
// Modules to build up the vent components
//
// This file instantiates the entire vent as a single object, use 
//   vent_left.scad and vent_right.scad for the individual parts
//
// *************************************************************


include <libs/Round-Anything/polyround.scad>
include <libs/roundedcube_simple.scad>

include <vent_parameters.scad>




// The hood attachment which connects the vent to the Creator Pro 2 hood
module hood_attachment() {

    difference() {

        // Base shape
        // translate( [ 0, hood_cover_total_width / 2 - epsilon/2, 0 ] )
        translate( [ 0, hood_cover_total_width / 2, 0 ] )
            rotate( [90, 0 , 0 ] )
                extrudeWithRadius( hood_cover_total_width, 
                                   hood_cover_back_radius, 
                                   hood_cover_front_radius, radiusExtrudefn ) 
                {
                    polygon( polyRound( hood_cover_outside_radiiPoints, fnn ) );
                };

        // Cut out side slots the hood slots into (on on both sides)
        cut_lenght = hood_hole_height * 2;
        translate( [ -hood_hole_top_width/2 - hood_cover_length_over_hood - hood_cover_x_dist/2 + hood_cover_length_over_hood/2, 
                      0, hood_cover_y_dist/2 ] )
        rotate( [ 0, asin( (hood_cover_x_dist-0.14) / hood_cover_y_dist ), 0 ] )
        rotate( [ 90, 0, -90 ] )
        translate( [ 0, 0, -hood_cover_length_over_hood/2 ])
        extrudeWithRadius( hood_cover_length_over_hood, hood_cover_front_radius/2, -hood_cover_front_radius*1.5, radiusExtrudefn )
        {
            square( [ hood_wall_width, cut_lenght ], center=true );
        };

        translate( [ hood_hole_top_width/2 + hood_cover_length_over_hood + hood_cover_x_dist/2 - hood_cover_length_over_hood/2, 
                     0, hood_cover_y_dist/2 ] )
        rotate( [ 0, -asin( (hood_cover_x_dist-0.14) / hood_cover_y_dist ), 0 ] )
        rotate( [ 90, 0, 90 ] )
        translate( [ 0, 0, -hood_cover_length_over_hood/2 ])
        extrudeWithRadius( hood_cover_length_over_hood, hood_cover_front_radius/2, -hood_cover_front_radius*1.5, radiusExtrudefn )
        {
            square( [ hood_wall_width, cut_lenght ], center=true );
        };
    
        // Cut out interior hole for venting
        translate( [ 0, hood_cover_total_width / 2, hood_cover_interior_dist_from_bottom ] )
        rotate( [90, 0 , 0 ] )
        extrudeWithRadius( hood_cover_total_width + epsilon, 0, -hood_cover_front_radius*3, radiusExtrudefn ) 
        {
            polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );
        };

    };

} // module hood_attachment()

// The curved vent behind the hood attachment point and rotates the vent 90 degrees to face the hose
module hood_corner() {
  
    translate( [ -inside_bottom_horz - hood_corner_curve, hood_cover_total_width/2 - epsilon, hood_cover_interior_dist_from_bottom - hood_corner_width ] )
    rotate_extrude( angle = hood_corner_angle, convexity = 2 )
    shell2d( hood_corner_width )
    translate( [ inside_bottom_horz + hood_corner_curve, hood_corner_width, 0 ] )
    polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );

} // moduel hood_corner()

// The end of the vent that attaches to the air ducts 
module hose_attachment() {

    translate( [ hose_attachment_location_x, hose_attachment_location_y, hose_attachment_location_z ] ) 
    rotate( [ 0, -90, 0 ] ) 
    union() {

        // Build the attachment for the hose
        translate( [ 0, 0, hose_attachment_stop_length - epsilon ] ) 
        linear_extrude( hose_attachment_length ) 
        difference() {
            circle( d = hose_attachment_od );
            circle( d = hose_attachment_od - hose_attachment_width * 2 );
        }

        // Build the attachment stop
        linear_extrude( hose_attachment_stop_length ) 
        difference() {
            circle( d = hose_attachment_od + hose_attachment_stop_protrusion * 2 );
            circle( d = hose_attachment_od - hose_attachment_width * 2 );
        }

        // To improve printing add a shelf to the attachment stop ring
        translate( [ 0, 0, hose_attachment_stop_length - epsilon ] )
        rotate_extrude( angle = 360 )
        translate( [ hose_attachment_od/2 - epsilon, 0, 0 ] )
        polygon( [ 
                   [ 0, 0 ],
                   [ hose_attachment_stop_protrusion + epsilon, 0 ],
                   [ 0, hose_attachment_stop_protrusion * hose_attachment_stop_protrusion_print_shelf ],
                 ]);

    }

}


// The vent section that connects the hose attachment to the curved section
module pipe() {

    // Subtract the outer and inner shapes to build the pipe
    difference() {

        // Build the outer shape of the pipe
        hull() {

            // The outside of the pipe attachment shape
            translate( [ hose_attachment_location_x - epsilon, hose_attachment_location_y, hose_attachment_location_z ] ) 
            rotate( [ 0, -90, 0 ] ) 
            linear_extrude( epsilon ) 
            circle( d = hose_attachment_od );

            // The outside of the curve shape
            translate( [ -(hood_corner_curve + inside_bottom_horz) + epsilon, 
                        hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                        hood_cover_interior_dist_from_bottom ] )
            rotate( [ 90, 0, 90 ] ) 
            linear_extrude( epsilon ) 
            offset( hood_corner_width )
            polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );
        
        }

        // Build the inner shape of the pipe to subtract
        hull() {

            // The inside of the pipe attachment shape
            translate( [ hose_attachment_location_x - epsilon, hose_attachment_location_y, hose_attachment_location_z ] ) 
            rotate( [ 0, -90, 0 ] ) 
            linear_extrude( epsilon*2 ) 
            circle( d = hose_attachment_od - hose_attachment_width * 2  );

            // The inside of the curve shape
            translate( [ -(hood_corner_curve + inside_bottom_horz) + epsilon, 
                        hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                        hood_cover_interior_dist_from_bottom ] )
            rotate( [ 90, 0, 90 ] ) 
            linear_extrude( epsilon*2 ) 
            polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );

        }

    }

}

module bolt_connector_bottom() {

    bolt_connector_bottom_radiiPoints = [
        [ -bolt_connector_width/2,  0,                      0 ],
        [ -bolt_connector_width/2,  bolt_connector_height,  bolt_connector_radius ],
        [  bolt_connector_width/2,  bolt_connector_height,  bolt_connector_radius ],
        [  bolt_connector_width/2,  0,                      0 ],
    ];

    translate( [ -(hood_corner_curve + inside_bottom_horz - bolt_connector_depth/2), 
                 inside_bottom_horz + hood_corner_curve + hood_corner_width, 
                 hood_cover_interior_dist_from_bottom - epsilon ] )
    rotate( [ 0, 0, -90 ] )
    difference() {

        // Build the connector shape
        hull() {

            // The connector shape itself
            rotate( [ 90, 0, 0 ] )
            linear_extrude( bolt_connector_depth ) 
            polygon( polyRound( bolt_connector_bottom_radiiPoints, fnn ) );

            // A shape in front of the connector to create a shape for 3 printing without supports
            translate( [ 0, -bolt_connector_depth, 0 ] )
            rotate( [ 180, 0, 0 ] )
            linear_extrude( epsilon ) 
            polygon( polyRound( bolt_connector_bottom_radiiPoints, fnn ) );

        }

        // Subtract the nut cutouts
        // The center cutout
        translate( [ 0, 0, bolt_connector_height/2 ] )
        rotate( [ 90, 0, 0 ] )
        cylinder( h = 200, d = bolt_connector_bolt_dia, center = true );

        // The bolt nut cutout
        translate( [ 0, -bolt_connector_capture_nut_depth/2 + epsilon, bolt_connector_height/2 ] )
        rotate( [ 90, 90, 0 ] )
        cylinder( h = bolt_connector_capture_nut_depth, d = bolt_connector_bolt_head_dia, center = true, $fn = 6 );

        // A cutout into the left part printing element for the head
        translate( [ 0, -bolt_connector_depth - bolt_connector_height/2 + bolt_connector_bolt_dia/2, bolt_connector_height/2 ] )
        rotate( [ 90, 0, 0 ] )
        cylinder( h = bolt_connector_height, d = bolt_connector_bolt_head_dia );

        // A shelf to make printing the head cutout easier
        head_shelf_height = ((bolt_connector_bolt_head_dia-bolt_connector_bolt_dia)/2) * hose_attachment_stop_protrusion_print_shelf;
        translate( [ 0, -bolt_connector_depth - bolt_connector_height/2 + bolt_connector_bolt_dia/2 - epsilon, bolt_connector_height/2 ] )
        rotate( [ 90, 0, 180 ] )
        cylinder( h = head_shelf_height, d1 = bolt_connector_bolt_head_dia, d2 = bolt_connector_bolt_dia);

    }  

}

module bolt_connector_top() {

    bolt_connector_top_radiiPoints = [
        [ -bolt_connector_width/2,  0,                      0 ],
        [ -bolt_connector_width/2,  bolt_connector_height,  bolt_connector_radius ],
        [  bolt_connector_width/2,  bolt_connector_height,  bolt_connector_radius ],
        [  bolt_connector_width/2,  0,                      0 ],
    ];

    path_slope = (  inside_top_left_vert - inside_top_right_vert ) /
                 (  inside_top_left_horz + inside_top_right_horz );
    path_x_mid = ( -inside_top_left_horz + inside_top_right_horz ) /2;
    path_y_mid = (  (inside_top_left_vert-hood_cover_interior_width) + (inside_top_right_vert-hood_cover_interior_width) ) / 2;

    path_bottom_slope = (  (inside_top_right_vert-hood_cover_interior_width) - 0 ) /
                        (  inside_top_right_horz - inside_bottom_horz );
    path_bottom_x_mid = ( inside_top_right_horz * 9                             + inside_bottom_horz ) / 10;
    path_bottom_y_mid = ( (inside_top_right_vert-hood_cover_interior_width) * 9 + 0 ) / 10;

    // Subtracts the bolt holes from the connector's shape
    difference() {

        // Creates the bolt connector by adding a print element to the bolt connector for the left part
        hull() {

            // Align to actual position on assembly
            translate( [ -(hood_corner_curve + inside_bottom_horz) + epsilon, 
                        hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                        hood_cover_interior_dist_from_bottom ] )
            rotate( [ 90, 0, 90 ] ) 

            // Builds the bolt connector and right part print elements
            hull() {

                // Position the bolt connector on the inner cover outline
                translate( [ path_x_mid , 
                            path_y_mid + epsilon, 
                            0 ] )
                rotate( [ 90, 0, 180 - atan( path_slope ) ] )
                rotate( [ 270, 0, 0 ] )
                linear_extrude( bolt_connector_depth, center=true ) 
                polygon( polyRound( bolt_connector_top_radiiPoints, fnn ) );

                // Position the element to hull against for the right part
                translate( [ path_bottom_x_mid , 
                            path_bottom_y_mid + epsilon, 
                            0 ] )
                rotate( [ 0, 0, 90 + atan( path_bottom_slope ) ] )
                linear_extrude( bolt_connector_depth, center=true ) 
                square( [ epsilon, bolt_connector_width/2 ], center = true );

            } // hull() to make the bolt connector part

            // A section of the base pipe to hull against for printing the left part
            translate( [ hose_attachment_location_x - epsilon*2, hose_attachment_location_y, hose_attachment_location_z ] ) 
            rotate( [ 0, -90, 0 ] ) 
            linear_extrude( epsilon ) 
            intersection() {
                difference() {
                    circle( d = hose_attachment_od );
                    circle( d = hose_attachment_od - hose_attachment_width );
                };
                translate( [ sin(interface_clip_pipe_section_angle_to_connect) * hose_attachment_od/2 - hose_attachment_od/2 * 0.1, 
                            cos(interface_clip_pipe_section_angle_to_connect) * hose_attachment_od/2 - hose_attachment_od/2 * 0.1,
                            0 ] ) 
                square(size = hose_attachment_od);
            }

        } // hull() to add the left part print element

        // Subtract the nut cutouts
        translate( [ -(hood_corner_curve + inside_bottom_horz) + epsilon, 
                    hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                    hood_cover_interior_dist_from_bottom ] )
        rotate( [ 90, 0, 90 ] ) 
        translate( [ path_x_mid , 
                    path_y_mid + epsilon, 
                    0 ] )
        rotate( [ 90, 0, 180 - atan( path_slope ) ] )
        rotate( [ 270, 0, 0 ] )
        union() {

            // The center cutout
            translate( [ 0, bolt_connector_height/2, 0 ] )
            cylinder( h = 200, d = bolt_connector_bolt_dia, center = true );

            // The bolt nut cutout
            translate( [ 0, bolt_connector_height/2, -bolt_connector_capture_nut_depth/2 + bolt_connector_depth/2 + epsilon ] )
            rotate( [ 0, 0, atan( path_slope ) - 90 ] )
            cylinder( h = bolt_connector_capture_nut_depth, d = bolt_connector_bolt_head_dia, center = true, $fn = 6 );

            // A cutout into the left part printing element for the head
            translate( [ 0, bolt_connector_height/2, -bolt_connector_height*10 - bolt_connector_depth/2 - bolt_connector_bolt_dia/2 ] )
            cylinder( h = bolt_connector_height*10, d = bolt_connector_bolt_head_dia );

            // A shelf to make printing the head cutout easier
            head_shelf_height = ((bolt_connector_bolt_head_dia-bolt_connector_bolt_dia)/2) * hose_attachment_stop_protrusion_print_shelf;
            translate( [ 0, bolt_connector_height/2, -bolt_connector_depth/2 - bolt_connector_bolt_dia/2 - epsilon ] )
            cylinder( h = head_shelf_height, d1 = bolt_connector_bolt_head_dia, d2 = bolt_connector_bolt_dia);

        }

    } // difference() to subtract the bolt holes

    // The inner outline to match position to during development
    // shell2d( epsilon ) 
    // polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );

}

// Line around middle of interface between two parts
module vent_interface_insert( width, depth, margin ) {

    difference() {
    
        // Build a line around the entire interface
        translate( [ -(hood_corner_curve + inside_bottom_horz) - epsilon, 
                    hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                    hood_cover_interior_dist_from_bottom ] )
        rotate( [ 90, 0, 90 ] ) 
        linear_extrude( depth + margin ) 
        shell2d( offset1 = hood_corner_width/2 + (width + margin)/2, offset2 = hood_corner_width/2 - (width + margin)/2 ) {
            polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );
        };

        // Remove the line on the bottom to prevent empty space overhang during printing
        translate( [ 0, 0, -cube_subtract_size/2 + hood_cover_interior_dist_from_bottom + hood_cover_interior_radius_bottom*1.25 - margin ] )
        cube( size = cube_subtract_size, center = true );

    };

}

// The attachment clip on the right part
// Note: This clip is not being used in favor of a bolt connector instead
module right_clip() {

    path_slope = (  inside_top_left_vert - inside_top_right_vert ) /
                 (  inside_top_left_horz + inside_top_right_horz );
    path_x_mid = ( -inside_top_left_horz + inside_top_right_horz ) /2;
    path_y_mid = (  (inside_top_left_vert-hood_cover_interior_width) + (inside_top_right_vert-hood_cover_interior_width) ) / 2;

    // Align to actual position on assembly
    translate( [ -(hood_corner_curve + inside_bottom_horz) + epsilon, 
                hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                hood_cover_interior_dist_from_bottom ] )
    rotate( [ 90, 0, 90 ] ) 

    // Position the clip on the inner cover outline
    translate( [ path_x_mid , 
                 path_y_mid + epsilon, 
                 0 ] )
    rotate( [ 90, 0, 270 - atan( path_slope ) ] )
    translate( [ 0, interface_clip_depth, 0 ] )
    rotate( [ 180, 0, 0 ] )
    linear_extrude( height = interface_clip_width + interface_insert_margin, center = true )
    polygon( points = [ 
                        [ 0,                    0 ], 
                        [ 0,                    interface_clip_depth ], 
                        [ interface_clip_depth, 0 ] 
                      ] );

    // The inner outline to match position to during development
    // shell2d( epsilon ) 
    // polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );

}

// The attachment clip on the left part
// Note: This clip is not being used in favor of a bolt connector instead
module left_clip() {

    path_slope = (  inside_top_left_vert - inside_top_right_vert ) /
                 (  inside_top_left_horz + inside_top_right_horz );
    path_x_mid = ( -inside_top_left_horz + inside_top_right_horz ) /2;
    path_y_mid = (  (inside_top_left_vert-hood_cover_interior_width) + (inside_top_right_vert-hood_cover_interior_width) ) / 2;

    // Align to actual position on assembly
    translate( [ -(hood_corner_curve + inside_bottom_horz) + epsilon, 
                hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                hood_cover_interior_dist_from_bottom ] )
    rotate( [ 90, 0, 90 ] ) 

    // Position the clip on the inner cover outline
    translate( [ path_x_mid , 
                 path_y_mid + epsilon, 
                 0 ] )
    union() {

        // The end of the clip that locks to the right inner piece
        translate( [ 0, 0, interface_clip_depth * 2 + interface_insert_margin ] )
        rotate( [ 90, 0, 90 - atan( path_slope ) ] )
        translate( [ -interface_clip_depth, -interface_clip_depth, 0 ] )
        linear_extrude( height = interface_clip_width - interface_insert_margin*2, center = true )
        polygon( points = [ 
                            [ 0,                    0 ], 
                            [ 0,                    interface_clip_depth ], 
                            [ interface_clip_depth, 0 ] 
                        ] );

        // The bracket between the clip end and the bracket to the left assembly
        rotate( [ 0, 0, 90 - atan( path_slope ) ] )
        translate( [ -interface_clip_depth*1.5 + epsilon, 0, -interface_clip_width/4 + interface_clip_depth * 2 + interface_insert_margin * 3] )
        roundedcube_simple( size = [ interface_clip_depth, interface_clip_width, interface_clip_width/2 ], 
                    center = true, radius = interface_insert_margin *2 );
        

    }


    // To make the clip possible to print hull the base of the clip with a section of
    // the base pipe to create a smooth vertical attachment point
    hull() {

        // The base of the bracket positioned within the assembley
        translate( [ -(hood_corner_curve + inside_bottom_horz) + epsilon, 
                    hood_cover_total_width/2 + hood_corner_curve + inside_bottom_horz, 
                    hood_cover_interior_dist_from_bottom ] )
        rotate( [ 90, 0, 90 ] ) 
        translate( [ path_x_mid , 
                 path_y_mid + epsilon, 
                 0 ] )
        rotate( [ 0, 0, 90 - atan( path_slope ) ] )
        translate( [ -interface_clip_depth + epsilon, 0, -interface_clip_depth - interface_insert_margin - epsilon*2 ] )
        roundedcube_simple( size = [ interface_clip_depth * 2, interface_clip_width, interface_clip_depth ], 
                     center = true, radius = interface_insert_margin *2 );

        // A section of the base pipe
        translate( [ hose_attachment_location_x - epsilon*2, hose_attachment_location_y, hose_attachment_location_z ] ) 
        rotate( [ 0, -90, 0 ] ) 
        linear_extrude( epsilon ) 
        intersection() {
            difference() {
                circle( d = hose_attachment_od );
                circle( d = hose_attachment_od - hose_attachment_width );
            };
            translate( [ sin(interface_clip_pipe_section_angle_to_connect) * hose_attachment_od/2 - hose_attachment_od/2 * 0.1, 
                         cos(interface_clip_pipe_section_angle_to_connect) * hose_attachment_od/2 - hose_attachment_od/2 * 0.1,
                         0 ] ) 
            square(size = hose_attachment_od);
        }


    }

    // The inner outline to match position to during development
    // shell2d( epsilon ) 
    // polygon( polyRound( hood_cover_inside_radiiPoints, fnn ) );

}


module vent() {

    hood_attachment();
    hood_corner();

    hose_attachment();
    pipe();

    bolt_connector_bottom();
    right_clip();
    left_clip();

}


// Instantiate the entire vent as a single object
vent();




