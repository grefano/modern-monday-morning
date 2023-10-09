/// @description Insert description here
// You can write your code in this editor




control_chart();

//beat_y_cam += (keyboard_check_pressed(vk_down)-keyboard_check_pressed(vk_up))/2
if !playing{
	beat_y_cam += (keyboard_check(vk_down)-keyboard_check(vk_up))*.5
	
} else {
	// fourth per minute = 64
	// fourth per seco nd = 1.05....
	// ex: fourth per second = 2
	var dur_fourth = 1/(fourth_per_min/60) // 1/(120/60) // 1/2 = .5 segundos
	// 1/(30/60) = 1/(1/2) = 1/1*2/1 = 2/1 = 2
	beat_y_cam += (delta_time/1000000)*4 / dur_fourth; // tem q andar 4 em durfourth segundos
}
beat_y_cam = clamp(beat_y_cam, 0, length_song-(chart_h/square_width)) // max: quantas beats tem na musica - o tanto q aparece na tela
var fourth_dur = 60/fourth_per_min;
beat_sec_cam = (beat_y_cam/4)*fourth_dur;

if keyboard_check_pressed(ord("R")){
	//gerar_setas("final_"+string(global.boss_info[1]), 10, 0)
}

ini_prefix = get_ini_key_prefix(selected_seta[2], selected_seta[0], selected_seta[1]);