/// @description Insert description here
// You can write your code in this editor






draw_chart();

tab_normal()
tab_portal()

//tab_final()

//control_edit();

draw_set_halign(fa_left)

draw_set_font(-1)

draw_text(20,20,"beat_y: " + string(beat_y_cam))
draw_text(20,40,"dur: " + string(dur_in_sec) + " segundos")

/*
fourth = 0		tempo = 0
fourth = 1		tempo = .5

*/

draw_text(20,60,"y_in_sec: " + string(beat_sec_cam))

control_draw_volume(global.boss_info[info_index.snd])

draw_text(20,80,string(selected_seta))
draw_text(20,100," yadd smooth cam: " + string(yadd_smooth_cam) + " beat y cam: " + string(beat_y_cam))

for(var i = 0; i < ds_list_size(selected_setas); i++){
	draw_text(mouse_x, mouse_y+10+i*20, string(selected_setas[| i]))
}

draw_text(20,140,"key: " + string(beat_y_cam * 15))
//path_add_point()