// DP SOB pcb format
module sob_pcb(
		width = SOB_pcb_width
	, height = SOB_pcb_height
	, thickness = SOB_pcb_thickness
	, pcb_corner_r = SOB_pcb_corner_radius // corner radius
	, drill_offset = SOB_drill_offset // mounting hole offset from edge of pcb
	, drill_r = SOB_drill_radius // mounting hole radius
	, colour = "ForestGreen"
){
	off_w = (width/2) - drill_offset;
	off_h = (height/2) - drill_offset;
	// The PCB
	color(colour, 1) render()
	linear_extrude(height = thickness, center = false, convexity = SOB_Convexity){
		difference(){
			minkowski(){
				square([width-(pcb_corner_r*2),height-(pcb_corner_r*2)], true);
				circle(r=pcb_corner_r);
			}
			for(coord = [
				[-off_w,-off_h],
				[-off_w,off_h],
				[off_w,off_h],
				[off_w,-off_h]
			]){
				translate([coord[0],coord[1],0]){
					circle(r=drill_r);
				}				
			}
		}
	}
}