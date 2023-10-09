/// @description Insert description here
// You can write your code in this editor





if global.paused{
	draw_set_alpha(.75)
	draw_rectangle_color(0, 0, room_width, room_height, c_dkgray, c_black,c_dkgray, c_black,false)
	draw_set_alpha(1)
	
	if keyboard_check_released(vk_f5){
		// ir pra charting daquela musica
		room_goto(rmCharting)
	}
	//debug
	if keyboard_check_pressed(vk_f1) game_restart()
	
	if keyboard_check_pressed(vk_f9){
		ini_open(global.boss_info[info_index.name])
		ini_song_clear()
		ini_close()
		ini_open(get_ini_name(global.boss_info[1], 0))
		ini_song_clear()
		ini_close()
	}
}
draw_set_font(fntMenuBosses)
draw_text(20,50,global.boss_info[1])
draw_set_font(-1)

//draw_rectangle()

//draw_healthbar(50, room_height-50, room_width-50,room_height-20, ,c_black, c_orange, c_orange, 0, true, true)