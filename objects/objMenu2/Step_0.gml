/// @description Insert description here
// You can write your code in this editor
real_dtime = delta_time/1000000 * 60;

var sel_add = keyboard_check_pressed(vk_right)-keyboard_check_pressed(vk_left);
chair_sel += sel_add
chair_sel = clamp(chair_sel, 0, array_length(global.bosses_info)-1)
global.boss_info = global.bosses_info[chair_sel]
if sel_add != 0 {
	audio_play_sound(sndChangeOption, 15, 0, 2)
	show_message(global.boss_info)
}
if mouse_check_button_pressed(mb_right){
	var bg_layer = layer_get_id("Background");
	var bg_id = layer_background_get_id(bg_layer);
	var bg_spr = layer_background_get_sprite(bg_id)
	var bg_to = bg_spr == sprMenuBg ? sprMenuBg2 : (bg_spr == sprMenuBg2 ? sprMenuBg3 : (bg_spr == sprMenuBg3 ? sprMenuBg : sprMenuBg))
	layer_background_change(bg_id, bg_to)
}

camera_set_view_size(view_camera[0],1280*cam_size_mult,720*cam_size_mult);
var camh = camera_get_view_height(view_camera[0])
var camw = camera_get_view_width(view_camera[0])
camera_set_view_pos(view_camera[0], room_width/2-camw/2, camh*(.25-(cam_size_mult-.5)*2*.25) );

if keyboard_check_released(vk_anykey){
	if !zoom_out_going{
		zoom_out_going = true;
	} else {
	//	zoom_out_going = false;
	//	cam_size_x = 0;
	//	cam_size_mult = cam_size_mult_start
	}
}

if zoom_out_going{
	if cam_size_x == 1 && !select_going{
		boss_fx_x = approach(boss_fx_x, 1, .05 * real_dtime)
	}
	//cam_size_x+=.05;
	cam_size_x = approach(cam_size_x, 1, .025 * real_dtime)
	
	cam_size_mult = cam_size_mult_start+animcurve_channel_evaluate(animcurve_get_channel(acMenu, "zoom_out"), cam_size_x)*(1-cam_size_mult_start);
}
if select_going{
	boss_fx_x = approach(boss_fx_x, 2, .05 * real_dtime);
	
	if boss_fx_x >= 2{
		// definindo ini do boss
		global.boss_info[1] = global.boss_info[1]
		
		if !instance_exists(objTransition){
			var t = instance_create_depth(0, 0, depth, objTransition);
			t.room_to = global.boss_info[0]
		}
		
		//gerar_setas("final_"+string(global.boss_info[1]), 40, 0)
		boss_fx_x = 0;
		select_going = false;
	
	}
}



if sel_add != 0 && chair_sel >= 0 && chair_sel <= 2{
	// mudou de seleção
	boss_fx_x = 0;
	array_resize(boss_fx_poss, 0)
	for(var i = 0; i < string_length(chairs[chair_sel][chairs_index.boss]); i++){
		boss_fx_poss[i] = random_range(-boss_fx_pos_amp, boss_fx_pos_amp);
	}
}
chair_sel = clamp(chair_sel, 0, 2)


if (keyboard_check_pressed(vk_enter) or keyboard_check_pressed(vk_space)) && cam_size_x >= 1 && !select_going{
			// selecionar boss
	// iniciar animação
	select_going = true;
	boss_fx_x = 0;
	
	audio_play_sound(sndSelect, 20, 0)
}



if keyboard_check_pressed(ord("R"))game_restart()