/// @description Insert description here
// You can write your code in this editor
//debug
//for(var i = 0; i < 3; i++){
//	write_ini_create(global.bosses_info[i][1],global.bosses_info[i][3]);
//}



surfa = surface_create(1000, 1000)

var chair_insts = ds_list_create();
collision_line_list(0, 540, room_width, 540, objMenuChair, true, true, chair_insts, true);
enum chairs_index{
	boss,
	inst,
	spr,
	xx,
	yy
}
chairs = [
			["Joshua", chair_insts[| 0], sprMCJoshua, 382, 482],
			["Gabriel", chair_insts[| 1], sprMCJoshua, 672, 490],
			["Diego", chair_insts[| 2], sprMCDiego, 936, 460]
		 ];

chair_sel = 0;

bosses_txt_poss = [
						[40, -180],
						[-20, -200],
						[-40, -210]
				  ]
bosses_spr_poss = [
						[0,   -80+80],
						[-30, -70+80],
						[-20, -60+80]
				  ]
boss_txt_yfinal = [15, 7, 4, 2, 2, 4, 8]

boss_fx_x = 0;
boss_fx_pos_amp = 15;
boss_fx_poss = [];
for(var i = 0; i < string_length(chairs[chair_sel][chairs_index.boss]); i++){
	boss_fx_poss[i] = random_range(-20, 20);
}
zoom_out_going = false;
select_going = false;

////show_message(instance_find(objMenu2, 0))


cam_size_mult_start = .5;
cam_size_mult = cam_size_mult_start;
cam_size_x = 0;
camera_set_view_size(view_camera[0],1280*cam_size_mult,720*cam_size_mult);
camera_set_view_pos(view_camera[0], room_width/2-camera_get_view_width(view_camera[0])/2, room_height/2-camera_get_view_height(view_camera[0])*.75);
cam_middle_pos = [camera_get_view_x(view_camera[0])+camera_get_view_width(view_camera[0])/2, camera_get_view_y(view_camera[0])+camera_get_view_height(view_camera[0])/2]




// debug
//for(i = 0 ; i < array_length(bosses_info) ; i++){
//	gerar_setas(bosses_info[i][1], 20, 0)
//}

