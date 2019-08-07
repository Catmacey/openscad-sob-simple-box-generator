// Top part of SOB box
module sob_box_top(
		overall_height = 10
	, lip_type = "inner"   // [inner|outer] which half of the lip is this?
	, cornerpad_thickness  // [float] height of the pads that support the pcb
){

	// This colour is of course completely optional :o)
	color("CornflowerBlue")
	union(){
		// Top face of the case
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

		// Pads that you can screw into from below
		// Start from the face down to the lip
		// Default is that they extend to the same height as the inner face of
		// the wall (not including the lip) but they can be thicker or thinner if you wish
		// NOTE: The holes are smaller holes cos we want interference to screw into
		cp_thickness = 
			(cornerpad_thickness != undef)
			?cornerpad_thickness
			:overall_height - (lip_type == "inner"?0:SOB_lip_thickness) - SOB_face_thickness
		;
		translate([0,0,overall_height - SOB_face_thickness - cp_thickness]){
			cornerpads(
				  drill = (SOB_drill_radius * 0.9)
				, thickness = cp_thickness
			);
		}


	}
}