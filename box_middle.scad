// Middle part of a SOB box
module sob_box_middle(
		overall_height = 10
	, lip_type = "outer"    // [inner|outer] which half of the lip is this?
	, xmember = 12          // [float] width of the crossmember. 0 for no crossmember
	, hollow = false        // [bool] solid or hollow base
	, cornerpad_thickness   // [float] height of the pads that support the pcb
	, withdrills = true     // [bool] do drill holes pierce through the bottom of the case
){
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

		// Pads that support the pcb
		// Default is that the corner pads in the middle part are flush
		// with the footrim but they can be thicker if you wish
		cp_thickness = 
			(cornerpad_thickness != undef)
			?cornerpad_thickness
			:SOB_foot_thickness
		;
		cornerpads(
			  drill = SOB_drill_radius
			, thickness = cp_thickness
		);
	}
}