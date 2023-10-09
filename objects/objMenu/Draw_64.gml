/// @description Insert description here
// You can write your code in this editor


draw_set_font(fntBossRoom)
set_text_align(5)

//for(var i = 0; i < ds_grid_width(bosses); i++){
//	draw_set_color(sel == i ? ( bosses[# i, 1] != noone ? c_red : c_dkgray ) : c_white)
//	
//	
//	
//	var yy = room_height*.33 + i*120
//	draw_text(room_width*.66, yy - (sel_boss_y-room_height*.5) , bosses[# i, 0]);
//	
//	draw_set_color(c_white)
//}  

draw_menu(menus[menu_atual]);

draw_set_font(-1)
set_text_align(1)