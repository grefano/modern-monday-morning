/// @description Insert description here
// You can write your code in this editor

if keyboard_check_pressed(vk_f3) debug_show = !debug_show

var kright, kleft, kup, kdown, kpath;
kright	= keyboard_check(ord("K"))
kleft	= keyboard_check(ord("F"))
kup		= keyboard_check(ord("J"))
kdown	= keyboard_check(ord("G"))
kpath	= keyboard_check(ord("Z"))
kright_p= keyboard_check_pressed(ord("K"))
kleft_p	= keyboard_check_pressed(ord("F"))
kup_p	= keyboard_check_pressed(ord("J"))
kdown_p	= keyboard_check_pressed(ord("G"))

var pressing_array = [kleft_p, kdown_p, kup_p, kright_p]
//for(a =0 ; a < 4; a++){
//	
//}

var holding_array = [kleft, kdown, kup, kright]
for(var s = 0; s < 4; s+=1){
	if pressing_array[s]{
		check_press_arrow(s);
	}
	
	var seta = p_arrows_hold_insts[s]; // pegar a instanci
	if holding_array[s]{
		p_arrows_hold[s]++;
		//show_message(string(["holding", s, holding_array]))
		
		//if seta{
		//	seta.acx = 0;
		//}
	} else if p_arrows_hold[s]
	{ // parou de segurar (pontuar hold)
		if instance_exists(p_arrows_hold_insts[s]){
			var hold = seta.inst_hold;
			var dur = hold.dur;
			var diff = abs(p_arrows_hold[s] - dur);
			var score_pass = dur/4;
		
		
			destroy_old_showhit(seta.x, seta.y);
		
			// dist 60, ["SICK", "GOOD", "MEH", "BAD"], [pass, pass*2, pass*3]
			var score_hold = medir_score(diff, [score_pass, score_pass*2, score_pass*3], ["SICK", "GOOD", "MEH", "BAD"])
		
			if seta.poisoned{
				if score_hold[1] < 3{ // se a seta for envenenada e tiver conseguido um score hold melhor que bad, ganha um bad
					points[3]++;
				} // caso contrario, é pq o jogador percebeu q fez merda ent n vai ganhar um bad
			} else {
				points[score_hold[1]]++;
			
				// criando o showhit
				var a = instance_create_depth(p_arrowfinal_pos[# s, 0],p_arrowfinal_pos[# s, 1]-showhit_y, depth, objShowHit);
				a.txt = string(score_hold[0])
			}
		}
		p_arrows_hold[s] = 0;
		p_arrows_hold_insts[s] = noone;
	}
	//show_debug_message(p_arrows_hold_insts)
}


//		particulas dos inputs
for(var i = 0; i < array_length(p_arrows_hold); i++){
	if p_arrows_hold[i]{
		var _col = global.arrows_colors[i];
		
		var cloud_color = make_color_hsv(color_get_hue(_col), color_get_saturation(_col)-100, color_get_value(_col))
		part_type_color1(global.ptype_arrow_press_cloud, cloud_color);
		//part_particles_create(global.part_sys, p_arrowfinal_pos[# i, 0], p_arrowfinal_pos[# i, 1], global.ptype_arrow_press_cloud, 1)
		
		part_type_color1(global.ptype_arrow_press_flare, _col);
		//part_particles_create(global.part_sys, p_arrowfinal_pos[# i, 0], p_arrowfinal_pos[# i, 1], global.ptype_arrow_press_flare, 1)
		
	}
}

//		animação holding
for(var i = 0; i < 4; i++){
	if holding_array[i]{
		// apertando aquela tecla
		// aumenta o x
		px_hold_fx[i]+=.05;
		if px_hold_fx[i] > 1{
			px_hold_fx[i] = 0;
		}
	} else if px_hold_fx[i] != 0{
		// não estiver apertando e o x for diferente de 0
		// x = 0
		px_hold_fx[i] = 0;
	}
}

// pausando
if !global.paused && p_pathing_frames[0] == noone{
	time += delta_time / 1000000;
	global.frame += 1; // bpm / 60 // outra opcao = += add
	
}
//show_debug_message(frame)

// destruindo setas fora da tela
var seta_fora = collision_rectangle(0, -150, room_width, -100, objSeta, true, true)
if seta_fora{
	if (!seta_fora.poisoned) points[4]++;
	instance_destroy(seta_fora.inst_hold)
	instance_destroy(seta_fora)
	
}
//show_debug_message(string(frame) + "   " + string(index_check*15 + global.song_start_delay*60))
// resetando o jogo com "R"
if keyboard_check_pressed(ord("R")){
	room_restart()
}

if global.song_start_delay * 60 == global.frame{
	//////show_message("é pra spawnar agr: " + string(time))
	audio_play_sound(global.boss_info[info_index.snd], 10, false)
	_offset_first_second[0] = global.frame;
	
}

/*
qnd clica: define a posição inicial com base no final do movimento anterior
enquanto segura: define a posição final com base na posição da seta definida pelo mouse
qnd solta: define o frame inicial com base no frame final (p_180_3_start="framefinal") e define o frame final
*/
//			pathing
ini_open(get_ini_name(global.boss_info[info_index.name], 1))
var frame_round = global.frame div 15 * 15;
var prefix_now = get_ini_key_prefix(0, frame_round, pathing_arrow_sel[0]);
if kpath{ // 180 210
	
	if p_pathing_frames[0] == noone{
		p_pathing_frames[0] = frame_round;
	
		//	buscando o final do movimento anterior pra definir a posição inicial desse movimento com base nele
		var _frame_check_final = frame_round;
		while(true){
			var _prefix_check_final = get_ini_key_prefix(0, _frame_check_final, pathing_arrow_sel[0])
			var find_finalx = ini_read_real("mec_move", _prefix_check_final+"_end_x",noone);
			var find_finaly = ini_read_real("mec_move", _prefix_check_final+"_end_y",noone);
			if find_finalx{ // achou o final
				//show_debug_message(find_finaly)
				// comparar posição achada com a posição inicial
				show_debug_message("achada: " + string([find_finalx, find_finaly]))
				//show_debug_message("deveria: " + string([global.default_arrow_poss[pathing_arrow_sel[0]][0],global.default_arrow_poss[pathing_arrow_sel[0]][1]]))
				ini_write_real("mec_move", prefix_now+"_start_x", find_finalx);
				ini_write_real("mec_move", prefix_now+"_start_y", find_finaly);
				return;
			} else if _frame_check_final < 0{
				return;
			}
			_frame_check_final-=15;
		}
	} else if pathing_arrow_sel[0] != noone{
		
		p_pathing_frames[1] = frame_round;

		global.frame += (15*(keyboard_check_pressed(ord("C"))-keyboard_check_pressed(ord("X"))))
		global.frame = global.frame  div 15 * 15
	}
} else {
	if p_pathing_frames[0] != noone{
		var prefix_end = get_ini_key_prefix(0, frame_round, pathing_arrow_sel[0])
		var mouse_pos_grid = set_pos_in_move_grid(mouse_x, mouse_y)
		ini_write_real("mec_move", prefix_end+"_end_y", mouse_pos_grid[1] + GRID_IMG*.5);
		ini_write_real("mec_move", prefix_end+"_end_x", mouse_pos_grid[0] + GRID_IMG*.5);
		ini_write_real("mec_move", get_ini_key_prefix(0, p_pathing_frames[0], pathing_arrow_sel[0])+"_start", p_pathing_frames[1]);
		

		
		p_pathing_frames[0] = noone;
		p_pathing_frames[1] = noone;
	}	
}
ini_close()
/*
var path_prefix = get_ini_key_prefix(0, frame_round, 0);
var end_pos = [noone, noone]
if kpath{
	if p_pathing_frames[0] != noone{
		// segurando
		p_pathing_frames[1] = frame;
		// definindo a posição final da seta com base no mouse
		//////show_message("ayo")
		if pathing_arrow_sel[0] != noone{
			p_arrowfinal_pos[# pathing_arrow_sel[0], 0] = mouse_x
			p_arrowfinal_pos[# pathing_arrow_sel[0], 1] = mouse_y
			show_debug_message(p_arrowfinal_pos[# pathing_arrow_sel[0], 0])
		}
		
		
	}
	if p_pathing_frames[1] == noone{// clicou
		 p_pathing_frames[0] = frame_round;
		 // buscando o final do movimento anterior pra definir a posição inicial desse movimento com base nele
		 var _frame_check_final = frame_round;
		 while(true){
			var _prefix_check_final = get_ini_key_prefix(0, _frame_check_final, 0)
			var find_finalx = ini_read_real("mec_move", _prefix_check_final+"_end_x",noone);
			var find_finaly = ini_read_real("mec_move", _prefix_check_final+"_end_x",noone);
			if find_finalx{ // achou o final
				ini_write_real("mec_move", path_prefix+"_start_x", find_finalx);
				ini_write_real("mec_move", path_prefix+"_start_y", find_finaly);
				return;
			} else if _frame_check_final < 0{
				return;
			}
			_frame_check_final-=15;
		 }
	}
	
	
} else if p_pathing_frames[0] != noone{ // acabou de sair do estado pathing
	//////show_message("parou de pathing")
	// define frame inicial
	var start_prefix	=	get_ini_key_prefix(0, p_pathing_frames[0], pathing_arrow_sel[0])
	var end_prefix		=	get_ini_key_prefix(0, p_pathing_frames[1], pathing_arrow_sel[0])
	ini_write_real("mec_move", start_prefix+"_start",	p_pathing_frames[1]);
	ini_write_real("mec_move", end_prefix+"_end_x",		p_arrowfinal_pos[# pathing_arrow_sel[0], 0]);
	ini_write_real("mec_move", end_prefix+"_end_y",		p_arrowfinal_pos[# pathing_arrow_sel[0], 1]);
	
	
	//show_debug_message(p_arrowfinal_pos[# pathing_arrow_sel[0], 0])

	// reseta frames
	p_pathing_frames[1] = noone;
	p_pathing_frames[0] = noone;
}
ini_close();
*/