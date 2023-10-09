/// @description Insert description here
// You can write your code in this editor

debug_show = false;

showhit_y = 80;
arrow_final_miny = 0;
// max = room_height
bpm = global.boss_info[info_index.bpm];
global.hp = 50;
// qp * dp = qb * db = 100
// dp = 100/qp

objAladim.image_index = 0;
p_arrowfinal_pos = ds_grid_create(4, 4) // p_arrowfinal_pos
b_arrowfinal_pos = ds_grid_create(4, 4)
p_arrows_hold = [0, 0, 0, 0]
b_arrows_hold = [0, 0, 0, 0]
p_arrows_hold_insts = [noone, noone, noone, noone];
for(var i = 0; i < 4; i++){
	//var yy = GRID_SIZE*2;
	//var xx_dist = i*GRID_SIZE*2
	//p_arrowfinal_pos[# i, 0] = 300+find_pos_move_grid(8, 0)[0] + xx_dist
	//p_arrowfinal_pos[# i, 1] = yy
	//b_arrowfinal_pos[# i, 0] = GRID_SIZE*2 + xx_dist
	//b_arrowfinal_pos[# i, 1] = yy
	
	ini_open(get_ini_name(global.boss_info[info_index.name], 1))
	
	var player_prefix = get_ini_key_prefix(0, 0, i)
	p_arrowfinal_pos[# i, 0] = ini_read_real("mec_move", player_prefix+"_start_x", noone)
	p_arrowfinal_pos[# i, 1] = ini_read_real("mec_move", player_prefix+"_start_y", noone)
//	show_message(string(["px",i,p_arrowfinal_pos[# i, 0]]))
	var boss_prefix = get_ini_key_prefix(1, 0, i)
	b_arrowfinal_pos[# i, 0] = ini_read_real("mec_move", boss_prefix+"_start_x", noone)
	b_arrowfinal_pos[# i, 1] = ini_read_real("mec_move", boss_prefix+"_start_y", noone)
	
	ini_close()
	
	//p_arrowfinal_pos[# i, 0] = global.default_arrow_poss[i][0]
	//p_arrowfinal_pos[# i, 1] = global.default_arrow_poss[i][1]
	
	//b_arrowfinal_pos[# i, 0] = global.default_arrow_poss[i][0]-650
	//b_arrowfinal_pos[# i, 1] = global.default_arrow_poss[i][1];
	/*
	p_arrowfinal_pos[# i, 0] = room_width-100 - i*100
	p_arrowfinal_pos[# i, 1] = 120 + irandom(3)*100;
	b_arrowfinal_pos[# i, 0] = 600 - i*100
	b_arrowfinal_pos[# i, 1] = 120 + irandom(3)*100
	*/
}
p_arrowfinal_pos_now = [[noone, noone],[noone, noone],[noone, noone],[noone, noone]];
p_arrowfinal_frame_next_start = [noone, noone, noone, noone];
p_pathing_frames = [noone, noone];
pathing_arrow_sel = [noone, noone]
pathing_poss = [[noone, noone],[noone, noone]]

points = [0, 0, 0, 0, 0] // sick, good, meh, bad, miss



#region normal config
/*
p_arrows_pos[# 0, 0] = room_width-100;
p_arrows_pos[# 0, 1] = 200
p_arrows_pos[# 1, 0] = room_width-200;
p_arrows_pos[# 1, 1] = 200
p_arrows_pos[# 2, 0] = room_width-300;
p_arrows_pos[# 2, 1] = 200;
p_arrows_pos[# 3, 0] = room_width-400;
p_arrows_pos[# 3, 1] = 200;
p_arrows_pos[# 4, 0] = room_width-500;
p_arrows_pos[# 4, 1] = 200;
p_arrows_pos[# 5, 0] = room_width-600;
p_arrows_pos[# 5, 1] = 200;
p_arrows_pos[# 6, 0] = room_width-700;
p_arrows_pos[# 6, 1] = 200;
p_arrows_pos[# 7, 0] = room_width-800;
p_arrows_pos[# 7, 1] = 200;
*/
#endregion

qtd_fourths_min = 100/60 * 64
//dur_fourth_sec = 60/qtd_fourths_min
dur_fourth_sec = 60/ (60 /60*16) // 60s / (100bpm/60s*16p)

index_check = 0;


time = 0
global.frame = 0;

_color_bg = 0;

px_hold_fx = [0, 0, 0, 0]
bx_hold_fx = [0, 0, 0, 0]

create_arrow = function(_player_or_boss, _frame, _seta){
	var values = get_ini_values(_player_or_boss, _frame, _seta);
	var frame_hit = _frame + room_height/values[ini_values.arrow]
	if values[ini_values.arrow] != noone {
		//show_message(_seta)
		var inst_seta = instance_arrow(frame_hit, _seta, values, _player_or_boss);
		arrow_define_hold(values, inst_seta)
			
		if values[ini_values.portal_arrow] != noone{
			arrow_define_portal(values, inst_seta, _frame)
		}
	}
}

draw_final_arrows = function()
{
	var dist_min = 30; 
	var dist_max = 50;
	var yadd_outline = 3;
	
	var add_value = 20;
	var add_saturation = -20;
	var arrow_colors_outline = [add_hsv(global.arrows_colors[0],0, add_saturation, add_value), add_hsv(global.arrows_colors[1],0, add_saturation, add_value), add_hsv(global.arrows_colors[2],0, add_saturation, add_value), add_hsv(global.arrows_colors[3],0, add_saturation, add_value)]
	
	//			efeito tlgd
	for(var s = 0; s < 4; s++){
		p_arrowfinal_pos[# s, 0] += lengthdir_x(p_arrowfinal_pos[# s, 2], p_arrowfinal_pos[# s, 3])
		p_arrowfinal_pos[# s, 1] += lengthdir_y(p_arrowfinal_pos[# s, 2], p_arrowfinal_pos[# s, 3])

		if p_arrows_hold[s]
		{
			var px_seta = p_arrowfinal_pos[# s, 0]
			var py_seta = p_arrowfinal_pos[# s, 1]
			var bx_seta = b_arrowfinal_pos[# s, 0]
			var by_seta = b_arrowfinal_pos[# s, 1]
			//var length_max = px_hold_fx[s] * 50;
			
			//show_message(string([s, px_seta]))
			
			draw_set_color(global.arrows_colors[s]);
			
			for(var i = 0; i < 10; i++){
				var dir = irandom(360/12)*12
				var dist_ang_side = 10
				var dist = 50 - irandom(10);
				draw_triangle(px_seta+lengthdir_x(dist, dir), py_seta+lengthdir_y(dist, dir), px_seta+lengthdir_x(dist_ang_side, dir+90), py_seta+lengthdir_y(dist_ang_side, dir+90), px_seta+lengthdir_x(dist_ang_side, dir-90), py_seta+lengthdir_y(dist_ang_side, dir-90), false)
			}
			
			draw_set_color(-1)
		}
	}	
	//			desenhando a seta mermo
	for(var i = 0; i < 4; i++){
		// player
		var scl = p_arrows_hold[i] ? 1.2 : 1;
		draw_set_color(c_white)
		draw_sprite_ext(sprArrow, 1, p_arrowfinal_pos[# i, 0], p_arrowfinal_pos[# i, 1], scl, scl, global.default_arrows_ang[i], c_white, 1)
	//	show_message(string([i, p_arrowfinal_pos[# i, 0]]))
		//draw_text_color(p_arrowfinal_pos[# i, 0], p_arrowfinal_pos[# i, 1], p_arrowfinal_pos[# i, 0], c_black, c_black, c_black, c_black, 1)
		
		//draw_circle(p_arrowfinal_pos[# i, 0], p_arrowfinal_pos[# i, 1], 10, true)
		
		// pathing
		if mouse_check_button_pressed(mb_left) && point_distance(mouse_x, mouse_y, p_arrowfinal_pos[# i, 0], p_arrowfinal_pos[# i, 1]) < 50{
			pathing_arrow_sel[0] = i;
			pathing_arrow_sel[1] = 0;
		}
		if pathing_arrow_sel[0] == i{
			draw_text_transformed(p_arrowfinal_pos[# i, 0], p_arrowfinal_pos[# i, 1], "pathing", .5, .5, 0)
		}
		
		// boss
		var scl = b_arrows_hold[i] ? 1.2 : 1;
		draw_sprite_ext(sprArrow, 1, b_arrowfinal_pos[# i, 0], b_arrowfinal_pos[# i, 1], scl, scl, i*90, c_white, 1)
	}
	for(var s = 0; s < 4; s++){
		if p_arrows_hold[s]
		{
			var x_seta = p_arrowfinal_pos[# s, 0]
			var y_seta = p_arrowfinal_pos[# s, 1]
			draw_set_color(global.arrows_colors[s]);
			for(var i = 0; i < 4; i++){
				
				var dir = 45+i*90
				var length = animcurve_channel_evaluate(animcurve_get_channel(acArrow, "fx_hold_line_size"), px_hold_fx[s]) * 25;
				var dist = dist_min + (dist_max-dist_min) * animcurve_channel_evaluate(animcurve_get_channel(acArrow, "fx_hold_line_dist"), px_hold_fx[s])
				
				var x1 = x_seta + lengthdir_x(dist, dir)
				var y1 = y_seta + lengthdir_y(dist, dir)
				var x2 = x_seta + lengthdir_x(dist+length, dir)
				var y2 = y_seta + lengthdir_y(dist+length, dir)
				draw_set_color(arrow_colors_outline[s])
				draw_line_width(x1, y1+yadd_outline, x2, y2+yadd_outline, 8)
				draw_set_color(global.arrows_colors[s]);
				draw_line_width(x1, y1, x2, y2, 8)
				
	
				
				var dist = 50;
				var ang_evalue = animcurve_channel_evaluate(animcurve_get_channel(acArrow, "fx_hold_arc_ang"), px_hold_fx[s])
				var ang1 = ang_evalue * 20
				var ang2 = (ang_evalue-1) * 20
				var x1 = x_seta + lengthdir_x(dist, i*90+ang1)
				var y1 = y_seta + lengthdir_y(dist, i*90+ang1)
				var x2 = x_seta + lengthdir_x(dist, i*90+ang2)
				var y2 = y_seta + lengthdir_y(dist, i*90+ang2)
				draw_set_color(arrow_colors_outline[s])
				draw_line_width(x1, y1+yadd_outline, x2, y2+yadd_outline, 4)
				draw_set_color(global.arrows_colors[s]);
				draw_line_width(x1, y1, x2, y2, 4)
				
			}
			
			draw_set_color(-1)
		}
	}	
}

_offset_first_second = [];

arrow_define_portal = function(_values, _inst, _frame){
	var delay = _values[ini_values.portal_delay] == noone ? 0 : _values[ini_values.portal_delay]
	var offset = _values[ini_values.portal_offset] == noone ? 0 : _values[ini_values.portal_offset]
	////show_message(string([delay, offset]))
			
	var fhit = _frame + round(room_height/_values[ini_values.arrow]);
	var time_catch = fhit - offset// nesse momento exato ocorre o teleporte (120-30=90)
	var time_leave = time_catch + delay// nesse momento exato a seta sai do outro portal (90+15=105)
			
	_inst.portal_f_catch = time_catch - global.anim_portal_intro * (60/sprite_get_speed(sprPortal)); // - anim before 
	_inst.portal_f_leave = time_leave - global.anim_portal_intro * (60/sprite_get_speed(sprPortal)); // - anim before   (105-3=102)
	_inst.portal_s_leave = _values[ini_values.portal_arrow]
	_inst.h_leave		 = abs(_values[ini_values.arrow])*(delay+offset) // 10*(45+)
}

arrow_define_hold = function(_values, _inst){
	if _values[ini_values.hold_dur]{
		var inst_hold = instance_create_depth(_inst.x, _inst.y, depth, objHold, {
			dur : _values[ini_values.hold_dur],
			seta : _inst,
			hold_h : abs(_inst.vspeed * _values[ini_values.hold_dur])
		});
		_inst.inst_hold = inst_hold;
	} else{
		_inst.inst_hold = noone;
	}
}