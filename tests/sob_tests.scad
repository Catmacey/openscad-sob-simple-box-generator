// Tests of SOB (Sick of Beige) Box generator

// Shows various combinations of inner and outer lip plus the 
// bottom face solid, hollow or with cross member.

$fn=32;

// Include the main sob.scad
include <../sob.scad>;

// Overwrite some defaults to define the PCB dimensions
SOB_pcb_width = 60;
SOB_pcb_height = 40;
SOB_lip_thickness = 4;

// Height of the upper part of the case
box_height_top = 10;
// Height of the middle (lower) part of the case
box_height_bottom = 10;

// NOTE: the overlapping lip is not included in the height


// Setup a slicer to show our inner geometry this has nothing
// to do the the case but is a handy way to demo the geometry

slice_x = 0;
slice_y = 23;
vertoff = 25;

// Setup a scene with multiple box parts
// Each one is sliced to show interior construction

translate([-70,0,0]){
	// Top shell lip in
	translate([0,0,vertoff])
	slice(slice_x,slice_y,1){
		sob_box_top(overall_height = box_height_top, lip_type = "inner");
	}
	// Middle shell lip out : Open (hollow) base
	slice(slice_x,slice_y,0){
		sob_box_middle(overall_height = box_height_bottom, lip_type = "outer",  hollow = true);
	}
}

translate([0,0,0]){
	// Top shell lip out
	translate([0,0,vertoff])
	slice(slice_x,slice_y,0){
		sob_box_top(overall_height = box_height_top, lip_type = "outer");	
	}
	// Middle shell lip in : open base with a crossmember
	slice(slice_x,slice_y,0){
		sob_box_middle(overall_height = box_height_bottom, lip_type = "inner", xmember = 8);
	}
}

translate([70,0,0]){
	// Top shell lip in
	translate([0,0,vertoff])
	slice(slice_x,slice_y,1){
		sob_box_top(overall_height = box_height_top, lip_type = "inner");
	}	
	// Middle shell lip out : solid base
	slice(slice_x,slice_y,0){
		sob_box_middle(overall_height = box_height_bottom, lip_type = "outer", xmember = 0);
	}
}


// Cuts things to show interior
// Nothing to do with the case.
module slice(x=0, y=0, z=0){
	width = SOB_pcb_width+6;
	height = SOB_pcb_height+6;
	depth = box_height_bottom+box_height_top+2;
	if(x >0 || y > 0 || z >0){
		translate([
			  (x > 0)?((width-x)/2):0
			, (y > 0)?-((height-y)/2):0
			, 0
		])
		difference(){
			children();
			translate([x,-y,-5])
			color("red")
			centered_cube([width, height, depth]);
		}
	}else{
		children();
	}
}