/// @description Insert description here
// You can write your code in this editor

//var debug_pos = set_pos_in_move_grid(current_time*.01, 100)
//draw_circle(debug_pos[0], debug_pos[1], 10, false)


if !surface_exists(surfa){
	surfa = surface_create(1000, 1000)
} else {
	surface_set_target(surfa)
	draw_circle(500, 500, 200, false)
	surface_reset_target()
	draw_surface(surfa, 0, 0)
}

draw_set_valign(fa_bottom)
draw_set_halign(fa_middle)
draw_set_font(fntMenuBosses)
//draw_text( chairs[chair_sel][1].x, chairs[chair_sel][1].bbox_top, chairs[chair_sel][0])

var txt_boss =  chairs[chair_sel][chairs_index.boss]
var txt_length = string_length(txt_boss)


		// desenhando cadeiras e personagens
for(var c = 0; c < array_length(chairs); c++){
	if chair_sel == c{
		shader_set(shdMenuSelChair)	
		var uni_ctime = shader_get_uniform(shdMenuSelChair, "c_time")
		shader_set_uniform_f(uni_ctime, current_time)
		var uni_addbright = shader_get_uniform(shdMenuSelChair, "add_bright")
		shader_set_uniform_f(uni_addbright, boss_fx_x)
	}
	//draw_sprite(chairs[c][chairs_index.spr], cam_size_x > .4, chairs[c][chairs_index.xx], chairs[c][chairs_index.yy])
	var xx = chairs[c][chairs_index.xx] + bosses_spr_poss[c][0]
	var yy = chairs[c][chairs_index.yy] + bosses_spr_poss[c][1]
	var cam_mult_to1 =  abs((cam_size_mult-cam_size_mult_start)*2-1)
	var xadd_zoom = cam_mult_to1 * lengthdir_x(30, point_direction(cam_middle_pos[0], cam_middle_pos[1], xx, yy));
	var yadd_zoom = cam_mult_to1 * lengthdir_y(30, point_direction(cam_middle_pos[0], cam_middle_pos[1], xx, yy));
	draw_sprite(sprPersos, c, xx + xadd_zoom, yy + yadd_zoom)
	shader_reset()
}

var x_txt_middle = chairs[chair_sel][chairs_index.inst].x;
//show_debug_message(boss_fx_x)
draw_bright(string_width(txt_boss)*2, 70, [bosses_txt_poss[chair_sel][0]+x_txt_middle-10, chairs[chair_sel][chairs_index.inst].y+bosses_txt_poss[chair_sel][1]-30], (cam_size_x == 1)*.5)
	
	// escrevendo o nome do boss selecionado
for(var i = 0; i < txt_length; i++){
	if cam_size_x == 1{
		
		
		var txt_x = x_txt_middle + bosses_txt_poss[chair_sel][0] + string_width(txt_boss)/2 - string_width(txt_boss) + i*20
		var txt_yadd_selected = select_going ? animcurve_channel_evaluate(animcurve_get_channel(acMenu, "boss_fx_sely"), boss_fx_x - abs(i-floor(txt_length/2))*.15) * 40: 0;
		var txt_y = chairs[chair_sel][chairs_index.inst].y + bosses_txt_poss[chair_sel][1] + boss_txt_yfinal[i] + boss_fx_poss[i] - txt_yadd_selected
		draw_set_color(make_color_hsv(255, 0, 150 - ( select_going==true ? 90*boss_fx_x : 0)))
		draw_text(txt_x, txt_y+ abs(boss_txt_yfinal[i]-10)*.5 ,string_char_at(txt_boss, i+1))
		draw_set_color(c_white)
		draw_text(txt_x, txt_y, string_char_at(txt_boss, i+1))
		//draw_set_color(c_white)
		
		//if (array_length(boss_fx_poss) == txt_length) boss_fx_poss[i] -= sign(boss_fx_poss[i]) * .67 * abs(animcurve_channel_evaluate(animcurve_get_channel(acMenu, "boss_fx_y"), boss_fx_x)-1);
		if (array_length(boss_fx_poss) == txt_length) boss_fx_poss[i] *= abs(animcurve_channel_evaluate(animcurve_get_channel(acMenu, "boss_fx_y"), boss_fx_x)-1);
	}
}

draw_set_valign(fa_top)
draw_set_halign(fa_left)

draw_text(20,20,array_length(boss_fx_poss))
draw_text(20,40, string_length(txt_boss))
draw_text(20,60,"vel multiplier: " + string(real_dtime))

//shader_set(shdTwirl);
//draw_circle(700,350,100,false)
//shader_reset();