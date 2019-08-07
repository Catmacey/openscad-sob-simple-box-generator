// Sick of Beige box creator

// Note the top and middle box parts overlap with a lip.
// The overall height of the part with the outer lip includes the lip.
// The overall height of the part with the inner lip does not include the lip
// By default the the middle part has the outer lip.

include <box_middle.scad>;
include <box_top.scad>;
include <pcb.scad>;

// Public variables
SOB_Convexity = 4;  // This helps with fast rendering and odd clipping

// Standard values : You can override these when you use the library
SOB_pcb_width = 100;
SOB_pcb_height = 80;
SOB_pcb_thickness = 1.6; // Standard PCB FR4 thickness
SOB_pcb_corner_radius = 4;
SOB_pcb_tolerance = 0.25;  // This the extra width/height we allow for fit
SOB_nozzle = 0.4;
// Ideal printable wall thickness 
// Should be multiple of nozzle width for best results
SOB_wall_thickness = (SOB_nozzle * 6);
SOB_drill_radius = 1.6;
SOB_drill_offset = 4; // offset of drill center from edge of board

SOB_face_thickness = 1; // Thickness of the top face
SOB_lip_thickness = 2; // This is the height of box joining lip
SOB_foot_thickness = 2; // This is the height of box foot lip


// Internal variables calculated from above
_SOB_box_inner_width = box_dimension_inner(SOB_pcb_width);
_SOB_box_outer_width = box_dimension_outer(SOB_pcb_width);
_SOB_box_inner_height = box_dimension_inner(SOB_pcb_height);
_SOB_box_outer_height = box_dimension_outer(SOB_pcb_height);
_SOB_box_lip_width = _SOB_box_inner_width + SOB_wall_thickness; 
_SOB_box_lip_height = _SOB_box_inner_height + SOB_wall_thickness;
_SOB_box_inner_r = box_radius_inner();
_SOB_box_outer_r = box_radius_outer();
_SOB_box_lip_r = box_radius_lip();


// Common modules

// 2d Rectangle with rounded corners
module rounded_rectangle(width=100, height=80, corner_r=4){
	minkowski(){
		square([width-(corner_r*2),height-(corner_r*2)], true);
		circle(r=corner_r);
	}
};

// Helper module: centered cube on (X,Y) but not on Z, like cylinder
module centered_cube(size){
  translate([-size[0]/2, -size[1]/2, 0])
    cube(size);
}

// Creates a simple wall
module sob_wall(height = 10){
	linear_extrude(height, convexity = SOB_Convexity)
	difference(){
		rounded_rectangle(_SOB_box_outer_width, _SOB_box_outer_height, _SOB_box_outer_r);
		rounded_rectangle(_SOB_box_inner_width, _SOB_box_inner_height, _SOB_box_inner_r);
	}
}

// Creates the inner and outer lips where the box overlaps
module sob_box_lip(type = "inner"){
	if(type == "outer"){
		// Outer lip
		linear_extrude(SOB_lip_thickness, convexity = SOB_Convexity){
			difference(){
				rounded_rectangle(
						_SOB_box_outer_width
					, _SOB_box_outer_height
					, _SOB_box_outer_r
				);
				rounded_rectangle(
						_SOB_box_lip_width
					, _SOB_box_lip_height
					, _SOB_box_lip_r
				);
			}
		};
	}
	if(type == "inner"){
		linear_extrude(SOB_lip_thickness, convexity = SOB_Convexity){
			difference(){
				rounded_rectangle(
						_SOB_box_lip_width
					, _SOB_box_lip_height
					, _SOB_box_lip_r
				);
				rounded_rectangle(
						_SOB_box_inner_width
					, _SOB_box_inner_height
					, _SOB_box_inner_r
				);
			}
		};
	}

}

// Plate for top or bottom
module face(thickness = SOB_foot_thickness, hollow = false, xmember, withdrills = false){
	linear_extrude(thickness, convexity = SOB_Convexity)
	difference(){
		// Face with a central xmember in the y
		#rounded_rectangle(_SOB_box_outer_width, _SOB_box_outer_height, _SOB_box_outer_r);
		if(hollow == true || xmember > 0){
			// Mostly an outer rim
			if(xmember > 0){
				// TODO: Add support for ymember that can combine with xmember to produce a central cross
				// Add a xmember
				inner_width = (SOB_pcb_width-SOB_wall_thickness-xmember)/2;
				translate([((inner_width/2)+(xmember/2)),0,0])
				rounded_rectangle(
					  inner_width
					, SOB_pcb_height-SOB_wall_thickness
					, SOB_pcb_corner_radius - (SOB_wall_thickness/2)
				);
				translate([-((inner_width/2)+(xmember/2)),0,0])
				rounded_rectangle(
					  inner_width
					, SOB_pcb_height-SOB_wall_thickness
					, SOB_pcb_corner_radius - (SOB_wall_thickness/2)
				);
			}else{
				// The missing bit from the middle
				rounded_rectangle(
					  SOB_pcb_width-SOB_wall_thickness
					, SOB_pcb_height-SOB_wall_thickness
					, SOB_pcb_corner_radius - (SOB_wall_thickness/2)
				);
			}
		}
		// TODO: Might be nice to do these after extrude and countersink them
		if(withdrills){
			// 4 mounting holes
			off_w = (SOB_pcb_width / 2) - SOB_drill_offset;
			off_h = (SOB_pcb_height / 2) - SOB_drill_offset;
			for(coord = [
				[-off_w,-off_h, 90],
				[-off_w,off_h, 0],
				[off_w,off_h, 90],
				[off_w,-off_h, 0]
			]){
				translate([coord[0],coord[1],0])
				circle(r=SOB_drill_radius);
			}				
		}
	}
}

// Cornerpads
// Places a cornerpad in all four corners of a rectangle that defines the centers of the drills
module cornerpads(
		drill = 2 // radius
	, thickness = 2 // extrusion
){
	// Offsets for centers of the corner drills
	off_w = (SOB_pcb_width - (SOB_drill_offset * 2)) / 2;
	off_h = (SOB_pcb_height - (SOB_drill_offset * 2)) / 2;
	for(coord = [
		[-off_w,-off_h, 90],
		[-off_w,off_h, 0],
		[off_w,off_h, 90],
		[off_w,-off_h, 0]
	]){
		cornerpad(
			, drill = drill
			, thickness = thickness
			, rotation = coord[2]
			, x = coord[0]
			, y = coord[1]
		);
	}
	// Inner module
	// Lens-ish shaped corner pad with hole
	module cornerpad (
		  size = 5 // x,y size of the pad
		, drill = 2 // radius of the drill
		, thickness = 2 // extrusion
		, rotation = 0
		, x = 0 // optional position
		, y = 0 // optional position
	){
		translate([x,y,0]){
			rotate([0,0,rotation]){
				linear_extrude(thickness, convexity = 10){
					difference(){
						hull(){
							square([size,size], false);
							translate([-size,-size,0]){
							 	square([size,size], false);
							}
							circle(size);
						}
						if(drill){
							circle(drill);
						}
					}
				}
			}
		}
	};
}





// Functions

function SOB_lip_thickness() = SOB_lip_thickness;

function box_dimension_inner(value) = value + (SOB_pcb_tolerance * 2);
function box_dimension_lip(value) = box_dimension_inner(value) + SOB_wall_thickness;
function box_dimension_outer(value) = box_dimension_inner(value) + (SOB_wall_thickness * 2);

function box_radius_inner() = SOB_pcb_corner_radius + SOB_pcb_tolerance;
function box_radius_lip() = SOB_pcb_corner_radius + SOB_pcb_tolerance + (SOB_wall_thickness / 2);
function box_radius_outer() = SOB_pcb_corner_radius + SOB_pcb_tolerance + SOB_wall_thickness;

// Convert absolute coords based on bottom left to relative to center
function xar(value) = value - (SOB_pcb_width / 2);
function yar(value) = value - (SOB_pcb_height / 2);