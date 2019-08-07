// Simple test of a 100 x 80 x 20 mm box

$fn=32;

// Include the main sob.scad
include <../sob.scad>;

// Overwrite some defaults
SOB_pcb_width = 100;
SOB_pcb_height = 80;
SOB_lip_thickness = 4;

box_height_top = 10;
box_height_bottom = 10;
vertical_offset = 10;

slice_x = 50;
slice_y = 0;

slice(slice_x,slice_y,0){
	// Top shell lip in
	color("red")
	translate([0,0,box_height_top + vertical_offset])
	sob_box_top(overall_height = box_height_top, lip_type = "inner");

	// Middle shell lip out
	sob_box_middle(overall_height = box_height_bottom, lip_type = "outer");
}





// Cuts things to show interior
module slice(x=0, y=0, z=0){
	width = SOB_pcb_width+6;
	height = SOB_pcb_height+6;
	depth = box_height_bottom+box_height_top+vertical_offset + 2;
	if(x >0 || y > 0 || z >0){
		translate([
			  (x > 0)?((width-x)/2):0
			, (y > 0)?-((height-y)/2):0
			, 0
		])
		difference(){
			children();
			translate([x,-y,-1])
			centered_cube([width, height, 100]);
		}
	}else{
		children();
	}
}