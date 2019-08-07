// Top part of SOB box
module sob_box_top(
		overall_height = 10
	, lip_type = "inner"
	, cornerpad_thickness
){
	// Box dimensions
	box_inner_width = box_dimension_inner(SOB_pcb_width);
	box_outer_width = box_dimension_outer(SOB_pcb_width);
	box_inner_height = box_dimension_inner(SOB_pcb_height);
	box_outer_height = box_dimension_outer(SOB_pcb_height);

	// TODO: Allow for flipping the lip

	box_lip_width = box_inner_width + SOB_wall_thickness; 
	box_lip_height = box_inner_height + SOB_wall_thickness;

	// Radiuses
	box_inner_r = box_radius_inner();
	box_outer_r = box_radius_outer();
	box_lip_r = box_radius_lip();

	color("CornflowerBlue")
	union(){
		// Abstact this into a SOB_face with optional hollows and crossmember
		translate([0,0,overall_height - SOB_face_thickness])
		face(thickness = SOB_face_thickness, hollow = false);

		// Wall and lip
		if(lip_type == "inner"){
			// Overall height does not include the lip
			translate([0,0,-SOB_lip_thickness]) sob_box_lip(type = lip_type);
			sob_wall(overall_height - SOB_face_thickness);
		}
		if(lip_type == "outer"){
			sob_box_lip(type = lip_type);
			translate([0,0,SOB_lip_thickness])
			sob_wall(overall_height - SOB_face_thickness - SOB_lip_thickness);
		}

		// MAYB: Write a function to calc this
		cpt = 
			(cornerpad_thickness != undef)
			?cornerpad_thickness
			:overall_height - (lip_type == "inner"?0:SOB_lip_thickness) - SOB_face_thickness
		;

		// Pads that you can screw into from below
		// Start from the face down to the lip
		// NOTE: Small holes cos we want interference to screw into
		translate([0,0,overall_height - SOB_face_thickness - cpt]){
			cornerpads(
				  box_width = SOB_pcb_width - (SOB_drill_offset * 2)
				, box_height = SOB_pcb_height - (SOB_drill_offset * 2)
				, size = 5
				, drill = (SOB_drill_radius * 0.9)
				, thickness = cpt
			);
		}


	}
}