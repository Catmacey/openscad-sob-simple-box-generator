// Simple test of a 50 x 31mm box

$fn=32;

// Include the main sob.scad
include <../sob.scad>;

// Overwrite some defaults
SOB_pcb_width = 50;
SOB_pcb_height = 31;
SOB_lip_thickness = 2;

box_height_top = 6;
box_height_bottom = 8;

// Setup the parts for simple placement in Cura

translate([0,-(SOB_pcb_height * .75), box_height_top])
mirror([0,0,1])
sob_box_top(overall_height = box_height_top, lip_type = "inner");

// Middle shell lip out
translate([0,(SOB_pcb_height * .75),0])
sob_box_middle(overall_height = box_height_bottom, lip_type = "outer", xmember=0);