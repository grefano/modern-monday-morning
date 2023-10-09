/// @description Insert description here
// You can write your code in this editor


////show_message(inst_hold)
var size = pressed ? animcurve_channel_evaluate(animcurve_get_channel(acArrow, poisoned ? "size_poison" : "size"), acx) : 1;

draw_sprite_ext(sprite_index, image_index, x, y, size, size, image_angle, poisoned ? c_black : image_blend, 1)

		draw_circle(x,y, 10, true)


// pressed && inst_hold.hold_h ) or ( pressed && inst_hold == noone
if pressed{
	if inst_hold == noone{
		acx += .15
	} else{
		if inst_hold.hold_h <= 0{
			acx += .15;
		}
	}
}
//if pressed && (inst_hold == noone && inst_hold.hold_h <= 0){
//	acx+=.15; 
//}
////show_message(inst_hold)
if acx >= 1{
	////show_message("fudi o hold")
	instance_destroy(inst_hold)
	instance_destroy()
}


if poisoned{
	var random_dist = 30;
	part_particles_create(global.part_sys, x+random_range(-random_dist,random_dist), y+random_range(-random_dist,random_dist), global.ptype_arrow_poison, 3);
}

if portal_f_catch != noone{
	//freeze(200, current_time)
	if global.frame == portal_f_catch{
		ini_open(get_ini_name(global.boss_info[info_index.name], 1))

		var yh_anim_intro = abs(global.anim_portal_intro*(60/sprite_get_speed(sprPortal))*vspeed)
		portal_insts[0] = instance_create_depth(x, y - yh_anim_intro, depth-1, objPortal)

		var poss_ini = ini_find_move(portal_f_leave, portal_s_leave, 0)
		var poss_final_seta = [	transform_scale(poss_ini[0][2], portal_f_leave, poss_ini[1][2],	poss_ini[0][0], poss_ini[1][0]),		
							    transform_scale(poss_ini[0][2], portal_f_leave, poss_ini[1][2],	poss_ini[0][1], poss_ini[1][1])] // 0, 0
							////show_message(  [poss_ini[0][2], portal_f_leave, poss_ini[1][2],	poss_ini[0][0], poss_ini[1][0]])
							//              startframe: 0,    fleave: 102,  closeframe: 252,   posstart: 0,    posend: 0
							//				startframe: 0,	  fleave: 102,  closeframe: 255,   posstart: 1226  posend: 1226
		var poss_leave = [poss_final_seta[0], poss_final_seta[1] + h_leave]
		//show_message("poss_leave: " + string(poss_leave) + " hleave: " + string(h_leave))
		
		portal_insts[1] = instance_create_depth(poss_leave[0], poss_leave[1], depth-1, objPortal)
		// tenho o frame e a seta final
		//alarm[0] = global.anim_portal_intro
		ini_close()
	}
}
if portal_insts[0] && portal_insts[0].image_index == global.anim_portal_intro{
	x = portal_insts[1].x
	y = portal_insts[1].y
	
	portal_insts[0] = noone;
	portal_insts[1] = noone;
}

draw_text(x,y,x)