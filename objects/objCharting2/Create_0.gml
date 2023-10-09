/// @description Insert description here
// You can write your code in this editor

//cam_dim = [camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0])]
cam_dim = [room_width, room_height]

timer_mousedrag_hold = 0;

enum sel_seta_values{
	frame,
	seta,
	p_ou_b
}

ini_final_chart = get_ini_name(global.boss_info[info_index.name], 0)
ini_create_chart = get_ini_name(global.boss_info[info_index.name], 1)

selected_seta = [0, 0, 0]; // frame, seta, player ou boss
selected_setas = ds_list_create();
selecting_setas = false;
selecting_setas_x1 = noone;
selecting_setas_y1 = noone;

beats_in_fourth = 4; // quantos beats ficam no meio de uma fourth
length_song = global.boss_info[info_index.len] // quantas beats tem na musia

fourth_per_min = global.boss_info[info_index.bpm];
var fourth_per_sec = fourth_per_min/60;
var beat_per_sec = fourth_per_sec*4;
var beat_dur = 1/beat_per_sec
dur_in_sec = beat_dur*length_song /// 1/(bpm/60*4)

beat_y_cam = 0;
beat_sec_cam = 0;

p_arrowfinal_pos = ds_grid_create(4, 2)
//player_paths_arrows = [path_add(),path_add(),path_add(),path_add()];
for(var i = 0; i < 4; i++){
	var randomx = room_width-GRID_IMG - i*100
	var randomy = 120 + irandom(3)*100;
	p_arrowfinal_pos[# i, 0] = randomx
	p_arrowfinal_pos[# i, 1] = randomy
	//path_add_point(player_paths_arrows[i], randomx,randomy, 100)
	//path_add_point(player_paths_arrows[i], randomx-100,randomy+200, 100)
	//path_add_point(player_paths_arrows[i], randomx,randomy+300, 100)

}


chart_x_boss =  room_width*.1;

chart_w = 200;
square_width = chart_w/4;
chart_h = room_height*.9;
chart_y = (room_height - chart_h + square_width)/2

chart_between = 25;

chart_x =chart_x_boss+chart_w+chart_between;
playing = false;



y_to_frame = function(_y){
	var i_my = floor((_y-(chart_y+yadd_smooth_cam))/square_width)
	var frame_my = ( i_my+floor(beat_y_cam) ) * 15;
	return frame_my
}
x_to_seta = function(_x){
	var i_my = floor((_x-chart_x)/square_width)
	return i_my
}
ds_list_find_array = function(_id, _array){
	for(var i = 0; i < ds_list_size(_id); i++){
		if array_equals(_array, _id[| i]) return true
		//show_message(string([_array, _id[| i]]))
	}
}

draw_chart_seta = function(_values, _chart_x, _seta_y, _s, _selected){
	var seta_size = square_width/sprite_get_width(sprArrow) * .9
	var color = _values[ini_values.poison] ? c_black : global.arrows_colors[_s]
			
	//var xx = _chart_x+chart_w - square_width/2 - _s*square_width
	var xx = _chart_x + square_width/2 + _s*square_width
			
	var h_hold =  max(_values[ini_values.hold_dur], 0) * (square_width/15)
	draw_line_width_color(xx, _seta_y, xx, _seta_y+h_hold, square_width/5, color, color)
	draw_sprite_ext(sprArrow, 0, xx, _seta_y, seta_size, seta_size, global.default_arrows_ang[_s], _selected ? c_aqua :  color, 1)
			
}
foreach_write_key_sel_seta = function(_sec, _sufix, _value){
	if selected_setas[| 0] != undefined{
		for(var i = 0; i < ds_list_size(selected_setas); i++){
			var _prefix = get_ini_key_prefix(0, selected_setas[| i][sel_seta_values.frame], selected_setas[| i][sel_seta_values.seta]);
			ini_write_real(_sec, _prefix+_sufix, _value)
		}
	} else {
		var _prefix = get_ini_key_prefix(0, selected_seta[sel_seta_values.frame], selected_seta[sel_seta_values.seta]);
		ini_write_real(_sec, _prefix+_sufix, _value)
	}
}
//show_debug_message(selected_setas[| 0])
foreach_delete_key_sel_seta = function(_sec, _sufix){
	if selected_setas[| 0] != undefined{
		for(var i = 0; i < ds_list_size(selected_setas); i++){
			var _prefix = get_ini_key_prefix(0, selected_setas[| i][sel_seta_values.frame], selected_setas[| i][sel_seta_values.seta]);
			ini_key_delete(_sec, _prefix+_sufix)
		}
	} else {
		var _prefix = get_ini_key_prefix(0, selected_seta[sel_seta_values.frame], selected_seta[sel_seta_values.seta]);
		ini_key_delete(_sec, _prefix+_sufix)
	}
}
draw_chart = function()
{
	
	draw_set_font(fntMenuBosses)
	draw_set_halign(fa_middle)
	draw_set_valign(fa_center)
	
	var chart_title_size = square_width/80
	
	draw_rectangle(chart_x, chart_y-square_width, chart_x+chart_w, chart_y,true)
	draw_rectangle(chart_x, chart_y, chart_x+chart_w, chart_y+chart_h, true);
	draw_text_transformed(chart_x+chart_w/2, chart_y-square_width/2, "ALADIM", chart_title_size, chart_title_size, 0)
	
	draw_rectangle(chart_x_boss, chart_y-square_width, chart_x_boss+chart_w, chart_y,true)
	draw_rectangle(chart_x_boss, chart_y, chart_x_boss+chart_w, chart_y+chart_h, true);
	draw_text_transformed(chart_x_boss+chart_w/2, chart_y-square_width/2, "BOSS", chart_title_size, chart_title_size, 0)
	
	draw_set_halign(-1)
	draw_set_valign(-1)
	draw_set_font(-1)


	for(var i = 0; i < chart_h/square_width; i++){
		// linhas horizontais
		var beat_line_y = chart_y+ i*square_width + yadd_smooth_cam
		if beat_line_y >= chart_y && beat_line_y <= chart_y+chart_h{
			draw_line_width(chart_x, beat_line_y, chart_x+chart_w, beat_line_y, (i+floor(beat_y_cam))%beats_in_fourth == 0 ? 3 : 1)
			draw_line_width(chart_x_boss, beat_line_y, chart_x_boss+chart_w, beat_line_y, (i+floor(beat_y_cam))%beats_in_fourth == 0 ? 3 : 1)
		}
		
		var seta_y = chart_y+square_width/2 + i*square_width + yadd_smooth_cam;
		ini_open(ini_final_chart)
		var key_i = ( i+floor(beat_y_cam) ) * 15
		// desenhando cada seta da linha
		
		////show_message(seta_size)
		
		
		for(var s = 0; s < 4; s++){
			var player_values = get_ini_values(0, key_i, s);
			if player_values[ini_values.arrow] != noone{
				var _selected = ds_list_find_array(selected_setas, [i*15,s,0]) or array_equals([i*15, s, 0], selected_seta)
				
				//show_message(string([[i*15,s,0],selected_seta, _selected]))
				draw_text(chart_x, seta_y, ds_list_find_index(selected_setas, [i*15,s,0]))
				draw_chart_seta(player_values, chart_x, seta_y, s, _selected)
			}
			var boss_values = get_ini_values(1, key_i, s);
			if boss_values[ini_values.arrow] != noone{
				//var _selected = ds_list_find_index(selected_setas, [i*15,s,1]) != undefined or selected_seta == [i*15, s, 1]
				draw_chart_seta(boss_values, chart_x_boss, seta_y, s, false)
			}
			
		}
		 
		ini_close()
		// desenhando seleção
		if key_i == selected_seta[0]{
			//draw_text(40, seta_y, "")
			//var offset_boss = selected_seta[2] == 1 ? chart_w+chart_between : 0
			var chart_xx = selected_seta[2] == 1 ? chart_x_boss : chart_x
			draw_circle(chart_xx + square_width/2 + selected_seta[1]*square_width, seta_y, square_width*.4,true)
		}
		
	}
	// linhas verticais
	for(var i = 0; i < 4; i++){
		var line_x = chart_x+i*square_width;
		draw_line(line_x, chart_y, line_x, chart_y+chart_h);
		
		var line_boss_x = chart_x_boss+i*square_width;
		draw_line(line_boss_x, chart_y, line_boss_x, chart_y+chart_h);
	}
	if selecting_setas{
		draw_rectangle(selecting_setas_x1, selecting_setas_y1, mouse_x, mouse_y, true)
	}
}
control_chart = function()
{
	yadd_smooth_cam = -frac(beat_y_cam)*square_width;
	
	var k_left_p, k_right_p, k_left_h, k_left_r;
	k_left_p = mouse_check_button_pressed(mb_left)
	k_left_r = mouse_check_button_released(mb_left)
	k_right_p = mouse_check_button_pressed(mb_right)
	k_left_h = mouse_check_button(mb_left)
	
	if k_left_p or k_right_p {
		// adicionar seta
		var _mouse_in_p_chart = ( mouse_x > chart_x && mouse_x < chart_x+chart_w ) && ( mouse_y > chart_y && mouse_y < chart_y+chart_h )
		var _mouse_in_b_chart = ( mouse_x > chart_x_boss && mouse_x < chart_x_boss+chart_w ) && ( mouse_y > chart_y && mouse_y < chart_y+chart_h )
		var _clicking_player_or_boss = _mouse_in_p_chart ? 0 : (_mouse_in_b_chart ? 1 : noone)
		
		// se estiver clicando na area da chart do player = 0, se estiver clicando na area do chart do boss = 1, caso contrario = noone
		if _clicking_player_or_boss != noone{ // está clicando em alguma chart
			//var seta_mx = abs(floor((mouse_x-())/square_width)-3)
			var clicking_tab_x = _clicking_player_or_boss == 0 ? chart_x : chart_x_boss
			var seta_mx = floor( (mouse_x-clicking_tab_x) / square_width )
			//show_message(seta_mx)
			// descobrir o i que o mouse clicou
			var frame_my = y_to_frame(mouse_y)
			//var i_my = floor((mouse_y-(chart_y+yadd_smooth_cam))/square_width)
			//var frame_my = ( i_my+floor(beat_y_cam) ) * 15;
			
			// transformar o i em key
			var key_my = get_ini_key_prefix(_clicking_player_or_boss, frame_my, seta_mx);
		//	show_message(key_my)
			
			ini_open(ini_final_chart)

			var seta_clicked = ini_read_real("setas", key_my, noone)
			if seta_clicked == noone && k_left_p{
				// colocando seta na key
				ini_write_real("setas", key_my, 10)
			}
			if k_right_p{
				ini_key_delete("setas", key_my)
				ini_key_delete("mec_hold", key_my+"_dur")
				ini_key_delete("mec_poison", key_my)
			}
			ini_close()
			
			selected_seta = [frame_my, seta_mx, _clicking_player_or_boss];

		}
	}
	var mouse_frame = y_to_frame(mouse_y);
	var dur = mouse_frame - selected_seta[0]
	
	if k_left_h && keyboard_check(vk_shift){
		timer_mousedrag_hold++;
		if timer_mousedrag_hold > 3{
			if !selecting_setas{
				// primeiro click
				selected_setas = ds_list_destroy(selected_setas)
				selected_setas = ds_list_create()
				selecting_setas_x1 = mouse_x
				selecting_setas_y1 = mouse_y
				selecting_setas = true;
			}
			
	
		}
	} else {
		timer_mousedrag_hold = 0;	
	}

	if k_left_r{
		if selecting_setas{
			
		
			var qtdw = ceil(abs(selecting_setas_x1-mouse_x)/square_width)
			var qtdh = ceil(abs(selecting_setas_y1-mouse_y)/square_width)
			
			var i1 = selecting_setas_x1 < mouse_x ? selecting_setas_x1 : mouse_x
			i1 = x_to_seta(i1)
			var i2 = selecting_setas_x1 > mouse_x ? selecting_setas_x1 : mouse_x
			i2 = x_to_seta(i2)
			var l1 = selecting_setas_y1 < mouse_y ? selecting_setas_y1 : mouse_y
			l1 = y_to_frame(l1)
			var l2 = selecting_setas_y1 > mouse_y ? selecting_setas_y1 : mouse_y
			l2 = y_to_frame(l2)
			//show_message(string([i1, i2, l1, l2]))
			
			
			for(var i = 0; i < qtdw; i++){
				for(var l = 0; l < qtdh; l++){
					ini_open(ini_final_chart)
					var temseta = ini_read_real("setas", get_ini_key_prefix(0, l1+l*15, i1+i), noone) != noone
					
					ini_close()
					if temseta{
						ds_list_add(selected_setas, [l1+l*15, i1+i, 0])

					}
				}

			}
			
			selecting_setas_x1 = noone
			selecting_setas_y1 = noone
			show_message("ayo")
		} else {
		
			var sel_seta = x_to_seta(mouse_x)
			var sel_frame = y_to_frame(mouse_y)
			ds_list_add(selected_setas, [sel_frame, sel_seta, 0])
		}
		selecting_setas = false;
	}
	


	
	
	if k_left_h{
			
		// se não ta segurando shift, seleciona só uma seta e arrasta pra definir hold dela
		if !selecting_setas{
			var prefix = "";
			if point_in_rectangle(mouse_x, mouse_y, chart_x, chart_y, chart_x+chart_w, chart_y+chart_h){
				prefix = get_ini_key_prefix(0, selected_seta[0], selected_seta[1])
			} else if point_in_rectangle(mouse_x, mouse_y, chart_x_boss, chart_y, chart_x_boss+chart_w, chart_y+chart_h){
				prefix = get_ini_key_prefix(1, selected_seta[0], selected_seta[1])
			}
			if prefix != ""{
				ini_open(ini_final_chart)
				ini_write_real("mec_hold", prefix+"_dur", dur)
				ini_close()
			}
		}
		//if point_in_rectangle(mouse_x, mouse_y, chart_x, chart_y, chart_x+chart_w, chart_y+chart_h){
		//	ini_open(get_ini_name(global.boss_info[info_index.name], 0))
		//	var prefix = get_ini_key_prefix(0, selected_seta[0], selected_seta[1])
		//	ini_write_real("mec_hold", prefix+"_dur", dur)
		//	ini_close()
		//} else if point_in_rectangle(mouse_x, mouse_y, chart_x, chart_y, chart_x+chart_w, chart_y+chart_h){
		//	ini_open(get_ini_name(global.boss_info[info_index.name], 0))
		//	var prefix = get_ini_key_prefix(1, selected_seta[0], selected_seta[1])
		//	ini_write_real("mec_hold", prefix+"_dur", dur)
		//	ini_close()
		//}
	}
	if keyboard_check_pressed(vk_space){
		// play na musica
		playing = !playing;
		if playing{
			audio_stop_sound(global.boss_info[2])
			var song = audio_play_sound(global.boss_info[2], 10, false)
			var fourth_dur = 1/(fourth_per_min/60);
			audio_sound_set_track_position(song,beat_sec_cam)
		} else { 
			audio_stop_sound(global.boss_info[2])
		}
	}
	
	if keyboard_check_pressed(vk_enter){
		// salvar ini create
		write_ini_create(global.boss_info[info_index.name], global.boss_info[info_index.bpm]);
		
		// iniciar a fase
		room_goto(rmGabriel)
	}
}

control_edit = function()
{
	ini_open(ini_final_chart)
	var ini_prefix = get_ini_key_prefix(selected_seta[2], selected_seta[0], selected_seta[1]);
	var arrow_spd = ini_read_real("setas", ini_prefix, noone)
	var arrow_hold_dur = ini_read_real("mec_hold", ini_prefix, noone)
	var arrow_poison = ini_read_real("mec_poison", ini_prefix, noone)
	
	
	var tab_sep = 20;
	var tab_w = 200;
	var tab_h = 300;
	var tab_normal_x = cam_dim[0]*.6
	var tab_normal_y = tab_sep;
	var tab_txt_sep = 20;
	var txt_between = 30;
	// botões fora das duas charts, uma aba pra modificar a seta selecionada e outra pra modificar as setas finais selecionadas
	draw_rectangle(tab_normal_x, tab_normal_y, tab_normal_x+tab_w, tab_normal_y+tab_h, true)
	draw_text(tab_normal_x+tab_txt_sep, tab_normal_y+tab_txt_sep,				"speed: " + noone_to_text(arrow_spd))
	draw_text(tab_normal_x+tab_txt_sep, tab_normal_y+tab_txt_sep+txt_between,	"hold: " + noone_to_text(arrow_hold_dur))
	//show_debug_message(noone_to_text(arrow_spd))
	var y_poison = tab_normal_y+tab_txt_sep+txt_between*2;
	draw_text(tab_normal_x+tab_txt_sep, tab_normal_y+tab_txt_sep+txt_between*2, arrow_poison == noone ? "poison" : "POISON")
	draw_rectangle(tab_normal_x, y_poison, tab_normal_x+tab_txt_sep+string_width("poison"),y_poison+string_height("p"), true)
	if mouse_check_button_pressed(vk_left){
		var mouse_col_poison = point_in_rectangle(mouse_x, mouse_y, tab_normal_x, y_poison, tab_normal_x+tab_txt_sep+string_width("poison"),y_poison+string_height("p"))
		if mouse_col_poison{
			if arrow_poison == noone{
				ini_write_real("mec_poison", ini_prefix, 1)
			} else {
				ini_key_delete("mec_poison", ini_prefix)
			}
		}
	}
	ini_close()
	
	//draw_text(tab_normal_x+tab_txt_sep, tab_normal_y+tab_txt_sep+20, "hold: " + string(arrow_hold_dur))

	/*
		setas normais:
			spd = int
			poison = bool
			portal = 
			hold = int (duração)
			
		setas finais:
			start or nothing or end = 3 bools
			x = int
			y = int
	*/
}
tab_values_size = .3
tab_title_size = .4;


sepy_values = 30;
sepy_top = 60;

tab_normal = function(){
	var x_right = cam_dim[0]-50;
	var y_top = 50;
	var tab_w = 180;
	var tab_h = 180;
	
	draw_rectangle(x_right-tab_w,y_top,x_right,y_top+tab_h,true);
	
	draw_set_halign(fa_middle)
	draw_set_valign(fa_top)
	draw_set_font(fntBossRoom)
		
	ini_open(ini_final_chart)
	
	control_value_tab(x_right-tab_w, y_top+sepy_top ,				"setas",		ini_prefix, 1, 30,				tab_w, 20, "spd:"	);						
	control_value_tab(x_right-tab_w, y_top+sepy_top+sepy_values,	"mec_hold",		ini_prefix+"_dur", 15, noone,	tab_w, 20, "dur:"	, 15);							
	control_value_tab(x_right-tab_w, y_top+sepy_top+sepy_values*2,	"mec_poison",	ini_prefix, 0, 1,				tab_w, 20, "poison:", 1);

	ini_close()
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
}

tab_final = function(){
	var x_right = cam_dim[0]-380;
	var y_top = 50;
	var tab_w = 300;
	var tab_h = 300;
	var sep_x = tab_w/4;
	var sep_y = 30;
	var sep_value = 35;
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
	draw_set_font(fntBossRoom)
	
	draw_rectangle(x_right-tab_w,y_top,x_right,y_top+tab_h,true);
	draw_line(x_right-tab_w*.33, y_top, x_right-tab_w*.33, y_top+tab_h)
	
	var txt_size = .4;
	var txt_coord_sepx = 20;
	var txt_coord_sepy = 30;
	ini_open(ini_final_chart)
	
	//draw_text_transformed(x_right-tab_w+txt_coord_sepx, y_top+sep_y, "x =", txt_size, txt_size, 0);
	draw_text_transformed(x_right - tab_w*.5, y_top+sep_y, "x", txt_size, txt_size, 0);
	//control_value_tab(x_right-tab_w*.5, y_top+sep_y+sep_value, "mec_move", ini_prefix+"_start_x", 0, 12, tab_w) // f seta pb
	
	//draw_text_transformed(x_right-tab_w*.66, y_top+sep_y, "y =", txt_size, txt_size, 0);
	draw_text_transformed(x_right - tab_w*.5, y_top+sep_y+tab_h*.25, "y", txt_size, txt_size, 0);
	//control_value_tab(x_right-tab_w*.5, y_top+sep_y+sep_value+tab_h*.25, "mec_move", ini_prefix+"_start_y", 0, 12, tab_w) // f seta pb
	
	
	var ini_switch_start	= ini_read_real("mec_move", ini_prefix+"_start", noone)
	var ini_switch_end		= ini_read_real("mec_move", ini_prefix+"_end", noone)

	var switch_ytop = y_top+tab_h-txt_coord_sepy;
	var switch_ybottom = y_top+tab_h-txt_coord_sepy+40;
	var switch_x = x_right-tab_w+txt_coord_sepx
	var switch_w = tab_w-txt_coord_sepx*2;
	var switch_xmid = switch_x + switch_w*.5
	var switch_sep = switch_w/3;
	
	draw_set_halign(fa_middle)
	
	draw_rectangle(switch_x, switch_ytop, switch_x+switch_w, switch_ybottom, true)
	draw_line(switch_xmid-switch_sep/2, switch_ytop, switch_xmid-switch_sep/2, switch_ybottom);
	draw_line(switch_xmid+switch_sep/2, switch_ytop, switch_xmid+switch_sep/2, switch_ybottom);
	var switch_txt_ytop = y_top+tab_h-sep_y+5
	draw_text_transformed(switch_xmid-switch_sep, switch_txt_ytop, "start"	, txt_size, txt_size, 0)
	draw_text_transformed(switch_xmid			, switch_txt_ytop, "fodac"	, txt_size, txt_size, 0)
	draw_text_transformed(switch_xmid+switch_sep, switch_txt_ytop, "end"	, txt_size, txt_size, 0)
	//var start_end_x = x_right-tab_w+txt_coord_sepx + ( ? tab_w-txt_coord_sepx*2/2 : 0)
	var switch_sel_x = switch_x + (ini_switch_start ? 0 : (ini_switch_end ? 2 : 1))*switch_sep
	draw_rectangle(switch_sel_x, switch_ytop, switch_sel_x+switch_sep, switch_ytop+5, false)
	var sel_switch = (mouse_x - switch_x)/(switch_sep);
	if mouse_check_button_pressed(mb_left){
		if mouse_y > switch_ytop && mouse_y < switch_ybottom{
			if floor(sel_switch) == 0{
				// start
				//ini_write_real("mec_move", ini_prefix+"start", )
				////show_message("startou")
			} else if floor(sel_switch) == 1{
				// nada
				////show_message("nadoukkk")
				
			} else if floor(sel_switch) == 2{
				// end
				////show_message("endou")
			}
		}
	}
	
	//draw_text_transformed(x_right-tab_w*.75+txt_coord_sepx, y_top+sep_y+txt_coord_sepy, "change", txt_size, txt_size, 0);
	draw_set_halign(-1)
	
	ini_close()


	
}
tab_portal = function(){
	var x_right = cam_dim[0]-40;
	var y_top = 400;
	var tab_w = 200;
	var tab_h = 180;
	
	draw_set_font(fntBossRoom)
	
	draw_rectangle(x_right-tab_w,y_top,x_right,y_top+tab_h,true);

	draw_set_halign(fa_middle)
	draw_text_transformed(x_right - tab_w/2, y_top + 15, "Mec. Portal", tab_title_size, tab_title_size, 0)
	
	
	ini_open(ini_final_chart)
	
	control_value_tab(x_right-tab_w, y_top+sepy_top,					"mec_portal", "_arrow",	0, 3,		tab_w, 20, "arrow:" )
	control_value_tab(x_right-tab_w, y_top+sepy_top+sepy_values,		"mec_portal", "_offset", 0, noone,	tab_w, 20, "offset:", 15)
	control_value_tab(x_right-tab_w, y_top+sepy_top+sepy_values*2,		"mec_portal", "_delay", noone, noone,tab_w, 20, "delay:" , 5)
	
	ini_close()
}