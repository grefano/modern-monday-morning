/// @description Insert description here
// You can write your code in this editor

image_alpha = .1
x = seta.x
y = seta.y

if seta.pressed{
	hold_h-=abs(spd);
	////show_message("ayo")
}

var w = 15;
if instance_find(object_index, 0) == id{
	////show_message(hold_h)
}
var cor = seta.image_blend
if portal_pos[0] == noone{ // não foi teleportado
	draw_line_width_color(x, y, x, y+hold_h, w, cor, cor)
	//draw_text(x,y+100,"h: " + string(hold_h) + " \n instseta: " + string(seta))
} else { // foi teleportado
//	var hold_h = vspd * dur
	var h_to_portal 	= min(hold_h, abs(portal_pos[1]-y))
	var h_to_final	= hold_h - h_to_portal
	draw_line_width_color(x, y, x, y + h_to_portal, w, cor, cor)
	draw_line_width_color(portal_pos[0], portal_pos[1], portal_pos[0], portal_pos[1] + h_to_final, w, cor, cor)
}