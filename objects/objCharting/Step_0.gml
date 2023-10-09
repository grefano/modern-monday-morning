/// @description Insert description here
// You can write your code in this editor






if keyboard_check_pressed(vk_enter){
	// testar
	// ir pra sala com essa chart
}
if keyboard_check_pressed(vk_f1){
	room_restart()
}

if playing{
	// cada batida tem 60 frames
	play_time++;
}

if keyboard_check_pressed(vk_enter){
	if !playing{
		audio_play_sound(song_to_chart, 10, true)
	} else {
		audio_stop_sound(song_to_chart)
	}
	
	playing = !playing;
	play_time = 0;
}

y_fourth += keyboard_check_pressed(vk_down)-keyboard_check_pressed(vk_up)

if keyboard_check_pressed(ord("R")){
	gerar_setas(ini_to_chart, 29, 0)
}