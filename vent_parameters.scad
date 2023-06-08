
// *************************************************************
//
// Vent parameters
//
// Most common to adjust are loacted at the top of the file
//
// *************************************************************



// Determines the Outer Diameter of the hose attachment 
hose_attachment_od                          = 99;           // Use for 4 inch hose
//hose_attachment_od                          = 75;           // Use for 3 inch hose


// Precision of rendering, final rendering values do take a bit but look nice

// Final rendering values
/*
$fa                                         = 1;
$fs                                         = 0.2;
fnn                                         = 30;       // Value used by RoundAnything library
radiusExtrudefn                             = 40;       // Value used by RoundAnything library
*/

// Edit rendering values
$fa                                         = 3;
$fs                                         = 1;
fnn                                         = 12;       // Value used by RoundAnything library
radiusExtrudefn                             = 10;       // Value used by RoundAnything library


// Controls the opening hole into the Creator Pro 2
hood_hole_bottom_width                      = 54.7 - 5;
hood_hole_top_width                         = 15.5 - 3;
hood_hole_height                            = 100  + 5;
hood_wall_width                             = 2.75 + 0.5;

// Controls the insert into the Creator Pro 2's hood
hood_cover_length_over_hood                 = 10;
hood_cover_width_around_hood                = 3;
hood_cover_outside_radius_top               = 8;
hood_cover_outside_radius_bottom            = 3;
hood_cover_front_radius                     = hood_cover_width_around_hood / 2;
hood_cover_back_radius                      = hood_cover_width_around_hood / 2;
hood_cover_total_width                      = hood_cover_width_around_hood * 2 + hood_wall_width;
hood_cover_x_dist                           = ( hood_hole_bottom_width/2 + hood_cover_length_over_hood ) -
                                              ( hood_hole_top_width/2 + hood_cover_length_over_hood ); 
hood_cover_y_dist                           = hood_hole_height;
hood_cover_interior_width                   = 5;
hood_cover_interior_radius_top              = 1;
hood_cover_interior_radius_middle           = 30;
hood_cover_interior_radius_bottom           = 7;
hood_cover_interior_dist_from_top           = 25;
hood_cover_interior_dist_from_bottom        = 9;

// Controls the curved segment between the Creator Pro 2 hood attachment and the hose attachment
hood_corner_curve                           = 10;
hood_corner_width                           = 5;
hood_corner_angle                           = 90;

// Controls the hose attachment pipe (the OD size of the pipe is at the top)
hose_attachment_width                       = 3;
hose_attachment_length                      = 25;
hose_attachment_stop_length                 = 5;
hose_attachment_stop_protrusion             = 3;
hose_attachment_stop_protrusion_print_shelf = 0.66;
hose_attachment_location_y                  = hose_attachment_od/2 + hose_attachment_stop_protrusion + 5;
hose_attachment_location_z                  = hose_attachment_od/2 + hose_attachment_stop_protrusion + hood_cover_interior_dist_from_bottom - hood_cover_interior_width;
hose_attachment_location_x_ratio            = 1.5;
hose_attachment_location_x                  = hose_attachment_location_x_ratio * -hose_attachment_location_y - hood_hole_bottom_width/2;

// Controls the bolt connector used to join the two parts
bolt_connector_height                       = 8;
bolt_connector_width                        = 10;
bolt_connector_depth                        = 6;
bolt_connector_radius                       = 3;
bolt_connector_bolt_dia                     = 3.5;
bolt_connector_bolt_head_dia                = 6.3;
bolt_connector_capture_nut_depth            = 1.5;

// Controls the insert wedge between the two parts
interface_insert_width                      = 1;
interface_insert_margin                     = 0.15;
interface_insert_depth                      = 4.5;

// Controls the clip to join the two parts (not used in favor of the bolt connector above)
interface_clip_width                        = 8;
interface_clip_depth                        = 1;
interface_clip_pipe_section_angle_to_connect= 60;

// Utility parameters
epsilon                                     = 0.01;
//$fn                                         = fnn;
cube_subtract_size                          = 500;



// The hood cover exterior radiiPoints
hood_cover_outside_radiiPoints = [
    [ -hood_hole_bottom_width/2 - hood_cover_length_over_hood, 0,                hood_cover_outside_radius_bottom ],
    [ -hood_hole_top_width/2    - hood_cover_length_over_hood, hood_hole_height, hood_cover_outside_radius_top ],
    [  hood_hole_top_width/2    + hood_cover_length_over_hood, hood_hole_height, hood_cover_outside_radius_top ],
    [  hood_hole_bottom_width/2 + hood_cover_length_over_hood, 0,                hood_cover_outside_radius_bottom ],
];

// The hood cover interior hole radiiPoints
//    Pre-calculate the vertical and horizontal points based on the slope from the top to bottom
//    to maintain a constant width while maximizing the opening
inside_bottom_vert          = hood_cover_interior_dist_from_bottom;
inside_bottom_horz          = hood_hole_top_width/2 + hood_cover_x_dist * ((hood_hole_height-inside_bottom_vert)/hood_hole_height) - hood_cover_interior_width;
inside_top_left_vert        = hood_hole_height - hood_cover_interior_dist_from_top;
inside_top_left_horz        = hood_hole_top_width/2 + hood_cover_x_dist * ((hood_hole_height-inside_top_left_vert)/hood_hole_height) - hood_cover_interior_width;
inside_top_right_vert       = hood_hole_height - hood_cover_interior_dist_from_top - inside_top_left_horz * 2 * 1.5;
inside_top_right_horz       = hood_hole_top_width/2 + hood_cover_x_dist * ((hood_hole_height-inside_top_right_vert)/hood_hole_height) - hood_cover_interior_width;
hood_cover_inside_radiiPoints = [
    [ -inside_bottom_horz,      0,                                                hood_cover_interior_radius_bottom ],
    [ -inside_top_left_horz,    inside_top_left_vert-hood_cover_interior_width,   hood_cover_interior_radius_top ],
    [  inside_top_right_horz,   inside_top_right_vert-hood_cover_interior_width,  hood_cover_interior_radius_middle ],
    [  inside_bottom_horz,      0,                                                hood_cover_interior_radius_bottom ],
];

