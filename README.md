

# Creator Pro 2 Hood Vent

An adapter to easily attach a vent hose to the back of the Creator Pro 2's existing hood and fully vent all fumes. Does not require modifying the hood or the Creator Pro 2 in any manner. Uses the Round Anything library to design the vent entirely with smooth edges. 

After connecting the adapter use the following to ensure all fumes are fully vented. 
1. Masking or duct tape to cover all of the openings around the bed chamber.
2. An inline vent fan to suck air through the vent. 

By reducing the number of openings for air to escape with tape and using a powerful enough vent fan you can ensure that all air will be drawn into the Creator Pro 2 through any remaining openings by the air being drawn into the vent. I used a basic 4 inch inline vent fan for this (AC Infinity RAXIAL S4 with 106 CFM, $29 off amazon) and found this to create enough air flow to keep the room fully fume free, or at least free enough that I no longer noticed any remaining fumes. That said this is likely the lowest airflow that will work and a larger fan might be better, I do plan to upgrade to a 6 inch fan with more air flow after migrating this setup to the basement. 

The adapter was designed in OpenSCAD which allows for generating new parts with new dimensions by simply adjusting individual parameters. For example, the diameter of the pipe attachment can easily be changed from 3 inches, 4 inches, 6 inches, etc. by modifying one parameter and the parts will be fully regenerated for the new size. 

# Printing

The adapter is divided into two parts for easier printing:

* `vent_right.scad` - The part that attaches to the Creator Pro 2's hood. Since the lip that wraps around the hood extends lower than the floor of the vent, short supports are needed on just the bottom of the part. I found any type of support to work well. The rest of the part uses angles and does not require supports.
* `vent_left.scad` - The part that attaches to the vent hose. Oriented so the hose attachment point is pointed downward. Does not require any supports. 

# Assembly

The two parts are joined together using M3 sized bolts and nuts. The nut opening is in a hex shape to fit the nut. It helps to first press the nut into the right side part so that is holds in place while screwing together. 

# OpenSCAD Files

* `vent_right.scad` - The right side part to print
* `vent_left.scad` - The left side part to print
* `vent_assembly.scad` - Shows the two parts next to each other, used to verify alignment after changes. 
* `vent.scad` - Utility modules to buils the parts
* `vent.parameters` - Utility modules to buils the parts

# Print Files

The following are pre-generated files for printing with a high number of facets for very smooth edges. 

* `Output/vent_right.stl` - The right side part to print
* `Output/vent_left_3_inch.stl` - The left side part to print for a 3 inch vent hose
* `Output/vent_left_4_inch.stl` - The left side part to print for a 4 inch vent hose





