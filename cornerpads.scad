// cornerpads

// Places a cornerpad in all four corners of a rectangle that defines the centers of the drills
module cornerpads(
	 	box_width = 100
	, box_height = 100
	, size = 10
	, drill = 2 // radius
	, thickness = 2 // extrusion
){
	// Offsets for centers of the corner drills
	off_w = (box_width / 2);
	off_h = (box_height / 2);
	for(coord = [
		[-off_w,-off_h, 90],
		[-off_w,off_h, 0],
		[off_w,off_h, 90],
		[off_w,-off_h, 0]
	]){
		cornerpad(
			  size = size
			, drill = drill
			, thickness = thickness
			, rotation = coord[2]
			, x = coord[0]
			, y = coord[1]
		);
	}
}

// Lens-ish shaped corner pad with hole
module cornerpad (
	  size = 10 // x,y size of the pad
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
