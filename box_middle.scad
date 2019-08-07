// Middle part of a SOB box
module sob_box_middle(
		overall_height = 10
	, lip_type = "outer"
	, xmember = 12
	, hollow = false
	, cornerpad_thickness
	, withdrills = true
){
	// Box dimensions
	box_inner_width = box_dimension_inner(SOB_pcb_width);
	box_outer_width = box_dimension_outer(SOB_pcb_width);
	box_inner_height = box_dimension_inner(SOB_pcb_height);
	box_outer_height = box_dimension_outer(SOB_pcb_height);

	box_lip_width = box_inner_width + SOB_wall_thickness; 
	box_lip_height = box_inner_height + SOB_wall_thickness;

	// Radiuses
	box_inner_r = box_radius_inner();
	box_outer_r = box_radius_outer();
	box_lip_r = box_radius_lip();

	union(){
		// Wall and lip
		translate([0,0,SOB_foot_thickness]){
			if(lip_type == "inner"){
				// Overall height does not include the lip
				translate([0,0,overall_height - SOB_foot_thickness]) sob_box_lip(type = lip_type);
				sob_wall(overall_height - SOB_foot_thickness);
			}
			if(lip_type == "outer"){
				translate([0,0,overall_height - SOB_foot_thickness - SOB_lip_thickness]) sob_box_lip(type = lip_type);
				sob_wall(overall_height - SOB_foot_thickness - SOB_lip_thickness);
			}
		}

		// Foot rim that the pcb sits on
		face(thickness = SOB_foot_thickness, hollow=true);
		// Thin xmember
		if(!hollow){
			face(thickness = SOB_foot_thickness/2, xmember = xmember, withdrills = withdrills);
		}


		// Default is that the corner pads in the middle part are flush
		// with the footrim
		cpt = 
			(cornerpad_thickness != undef)
			?cornerpad_thickness
			:SOB_foot_thickness
		;

		// Pads that support the pcb
		cornerpads(
			  box_width = SOB_pcb_width - (SOB_drill_offset * 2)
			, box_height = SOB_pcb_height - (SOB_drill_offset * 2)
			, size = 5
			, drill = SOB_drill_radius
			, thickness = cpt
		);
	}
}