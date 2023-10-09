global.hits_dist_score = [30, 50, 80, 100]
 // (ou igual) menor q o primeiro valor é sick, menor q o segundo é good, menor q o terceiro é meh e maior q o terceiro é bad
global.arrows_colors = [ make_color_hsv(0, 200, 200),  make_color_hsv(60, 200, 200),
make_color_hsv(120, 200, 200),  make_color_hsv(180, 200, 200)]
global.volume = .5;

global.song_start_delay = 2; // som inicia dps de X segundos
global.anim_portal_intro = 8; // tempo q demora pra chegar no frame de teleportar

enum info_index {
	sala,
	name,
	snd,
	bpm,
	len,
	anim,
	danob,
	danop
} 
global.bosses_info = [ // sala, .ini
						[rmJoshua, "joshua", song60, 60, sprGabrielDance, 16, [], undefined, undefined],
				 		[rmGabriel, "gabriel", sndSongChopSuey, 127, 400, [sprGabIdle, sprGabR, sprGabU, sprGabD, sprGabL], undefined, undefined], 
						[rmDiego, "diego", sndSongCabare, 130, sprGabrielDance, 120, [], undefined, undefined]
					]
global.boss_info = [];



//function set_pos_in_move_grid(_x, _y){
//	var _img = GRID_IMG
//	var _size = GRID_SIZE
//	var _ofs = GRID_OFFSET
//	var _size_final = _size+ (_ofs * _size/_img);
//	var repair_offset = GRID_IMG * .25
//		
//	var _xs = (_x-repair_offset) div _size_final * _size_final
//	var _ys = (_y-repair_offset) div _size_final * _size_final
//	return [_xs, _ys]
//}

	


enum ini_values{ // s_atual, s_hold_dur, s_poison, s_portal_arrow, s_portal_offset, s_portal_delay
	arrow,
	hold_dur,
	poison,
	portal_arrow,
	portal_offset,
	portal_delay
}
enum ini_values_move{
	start,
	x_start,
	y_start,
	x_close,
	y_close
}

enum ini_sections{
	arrow,
	poison,
	portal,
	hold
}



function get_ini_key_prefix(_player_or_boss, _frame, _arrow = noone){
	var prefix = (_player_or_boss ? "b" : "p") + "_" + string(_frame)
	if _arrow != noone prefix = prefix + "_" + string(_arrow)
	
	return prefix;
	//////show_message(_arrow)
}

//function get_ini_key(_which_key, _player_or_boss = 0, _frame, _arrow, _mec, _portal_ofs_or_delay){
//	/* # boss / player _ frame # <-- necessario pra identificar a seta
//	[setas] boss / player _ frame _ seta = spd
//	[mec_portal] boss / player _ frame _ seta _ delay / offset = int
//	[mec_poison] boss / player _ frame _ seta = bool
//	[mec_hold] boss / player _ frame _ seta = dur
//	*/
//	// obj_frame_seta
//	if _mec == ini_sections.arrow or _mec == ini_sections.poison or _mec == ini_sections.portal{
//		return prefix;
//	} else {
//		return prefix + "_" + (_portal_ofs_or_delay ? "ofset" + "delay")
//	}
//	var _who = _player_or_boss == 0 ? "p" : "b"
//	if _which_key == ini_keys.arrow{
//		return string(_who+"_"+string(_frame)+"_"+string(_arrow));
//	} else if _which_key == ini_keys.mec_bool{
//		return string(_who+"_"+string(_frame)+"_"+string(global.ini_mecs[_mec])+"_"+string(_arrow));
//	}
//	return noone;
//}
// forma de criar o ini_create que mudava o passo do frame
// mas agora o passo do frame é sempre 1 (ou seja, a cada 60 passos é 1 segundo) e eu altero a hora de criar no ini
// ex: bpm = 120     final: {0 60 120}    create: delay + {0 30 60}

function write_ini_mecs_keys(_player_or_boss, _boss, _values, _add, _frame, _delay, _seta){
	var portal_delay = max(_values[ini_values.portal_delay], 0)

	// pegar o tempo da ini_final e subtrair o tempo q a seta vai levar para chegar no final
	var time_pra_chegar = ( room_height / _values[ini_values.arrow] )
	var time_create = ( _frame ) / _add
	var _f_player = (round(time_create) - time_pra_chegar + round(_delay) - portal_delay)
	var _f_boss = (round(time_create) + round(_delay))
	var key_prefix = get_ini_key_prefix(_player_or_boss, _player_or_boss ? _f_boss : _f_player, _seta)
	
	ini_open(get_ini_name(_boss, 1))
				
	ini_write_real("setas",			key_prefix,			round(_values[ini_values.arrow]))
	ini_write_real("mec_poison",	key_prefix,				_values[ini_values.poison])
	ini_write_real("mec_hold",		key_prefix+"_dur",		_values[ini_values.hold_dur])
	ini_write_real("mec_portal",	key_prefix+"_arrow",	_values[ini_values.portal_arrow])
	ini_write_real("mec_portal",	key_prefix+"_offset",	_values[ini_values.portal_offset])
	ini_write_real("mec_portal",	key_prefix+"_delay",	_values[ini_values.portal_delay])

	ini_close()
}
function write_ini_move_keys(_player_or_boss, _boss, _values, _mvalues, _add, _frame, _delay, _seta){
	var time_create = _frame / _add
				
	var _f_start =	(round(time_create) + round(_delay))
	var _f_end =	(round(time_create) + round(_delay)) + (_values[ini_values.arrow]-_frame)
				
	var key_prefix_start = get_ini_key_prefix(, _f_start, _seta)
	var key_prefix_end = get_ini_key_prefix(0, _f_end, _seta)
				
	var _start_poss = [_mvalues[ini_values_move.x_start], _mvalues[ini_values_move.y_start]];
	var _end_poss = [ini_read_real("mec_move", key_prefix_end+"_end_x", noone), ini_read_real("mec_move", key_prefix_end+"_end_y", noone)]
				
	ini_open(get_ini_name(_boss, 1))
	ini_write_real("mec_move", key_prefix_start+"_start",	round(_f_end))
	ini_write_real("mec_move", key_prefix_start+"_start_x", round(_start_poss[0]))
	ini_write_real("mec_move", key_prefix_start+"_start_y", round(_start_poss[1]))
	ini_write_real("mec_move", key_prefix_start+"_end_x",	round(_end_poss[0]))
	ini_write_real("mec_move", key_prefix_start+"_end_y",	round(_end_poss[1]))
	ini_close()
}

function write_ini_create(_boss, _bpm){
	// transforma a ini com o tempo de chegada em um ini com o tempo de criação da seta
	ini_open(get_ini_name(_boss, 1))
	ini_song_clear()
	ini_close()
	var length_song = global.boss_info[info_index.len];
	var qtd_arrows_boss = 0;
	var qtd_arrows_player = 0;
	
	for(var i = 0; i < length_song; i++){
		for(var s = 0; s < 4; s++)
		{
			ini_open(get_ini_name(_boss, 0))
			//var seta_spd = ini_read_real("setas", get_ini_key_prefix(0, i*15, s), noone)
			var player_values = get_ini_values(0, i*15, s)
			var p_move_values = get_ini_move_values(0, i*15, s);
			var boss_values	  = get_ini_values(1, i*15, s)
			var b_move_values = get_ini_move_values(1, i*15, s)
			//		var seta_spd = ini_read_real("setas", get_ini_key(ini_keys.arrow, 0, i*15, s, 0), noone)
			ini_close()
			
			var add = _bpm/60
			var _delay = global.song_start_delay*60
			
			
			if player_values[ini_values.arrow] != noone{
				write_ini_mecs_keys(0, _boss, player_values, add, i*15, _delay, s)
				qtd_arrows_player++;
			}
			if boss_values[ini_values.arrow] != noone{
				write_ini_mecs_keys(1, _boss, boss_values, add, i*15, _delay, s)
				qtd_arrows_boss++
			}
			if p_move_values[ini_values_move.start] != noone{
				write_ini_move_keys(0, _boss, player_values, p_move_values, add, i*15, _delay, s)
			}
			if b_move_values[ini_values_move.start] != noone{
				write_ini_move_keys(1, _boss, boss_values, b_move_values, add, i*15, _delay, s)
			}
			#region
			/*
			if player_values[ini_values.arrow] != noone{
				var portal_delay = max(player_values[ini_values.portal_delay], 0)

				// pegar o tempo da ini_final e subtrair o tempo q a seta vai levar para chegar no final
				var time_pra_chegar = ( room_height / player_values[ini_values.arrow] )
				var time_create = ( i*15 ) / add
				var _f = (round(time_create) - time_pra_chegar + round(_delay) - portal_delay)
				var key_prefix = get_ini_key_prefix(0, _f, s)
				
				ini_open(get_ini_name(_boss, 1))
				
				ini_write_real("setas", key_prefix, round(player_values[ini_values.arrow]))
				ini_write_real("mec_poison", key_prefix, player_values[ini_values.poison])
				ini_write_real("mec_hold", key_prefix+"_dur", player_values[ini_values.hold_dur])
				ini_write_real("mec_portal", key_prefix+"_arrow", player_values[ini_values.portal_arrow])
				ini_write_real("mec_portal", key_prefix+"_offset", player_values[ini_values.portal_offset])
				ini_write_real("mec_portal", key_prefix+"_delay", player_values[ini_values.portal_delay])

				ini_close()
			}
			
			if boss_values[ini_values.arrow] != noone{
				var portal_delay = max(boss_values[ini_values.portal_delay], 0)

				// pegar o tempo da ini_final e subtrair o tempo q a seta vai levar para chegar no final
				var time_pra_chegar = ( room_height / boss_values[ini_values.arrow] )
				var time_create = ( i*15 ) / add
				var _f = (round(time_create) - time_pra_chegar + round(_delay) - portal_delay)
				var key_prefix = get_ini_key_prefix(1, _f, s)
				
				ini_open(get_ini_name(_boss, 1))
				
				ini_write_real("setas", key_prefix, round(boss_values[ini_values.arrow]))
				ini_write_real("mec_poison", key_prefix, boss_values[ini_values.poison])
				ini_write_real("mec_hold", key_prefix+"_dur", boss_values[ini_values.hold_dur])
				ini_write_real("mec_portal", key_prefix+"_arrow", boss_values[ini_values.portal_arrow])
				ini_write_real("mec_portal", key_prefix+"_offset", boss_values[ini_values.portal_offset])
				ini_write_real("mec_portal", key_prefix+"_delay", boss_values[ini_values.portal_delay])

				ini_close()
			}
			
			if p_move_values[ini_values_move.start]{
				var time_create = ( i*15 ) / add
				
				var _f_start =	(round(time_create) + round(_delay))
				var _f_end =	(round(time_create) + round(_delay)) + (player_values[ini_values.arrow]-i*15)
				
				var key_prefix_start = get_ini_key_prefix(0, _f_start, s)
				var key_prefix_end = get_ini_key_prefix(0, _f_end, s)
				
				var _start_poss = [p_move_values[ini_values_move.x_start], p_move_values[ini_values_move.y_start]];
				var _end_poss = [ini_read_real("mec_move", key_prefix_end+"_end_x", noone), ini_read_real("mec_move", key_prefix_end+"_end_y", noone)]
				
				ini_open(get_ini_name(_boss, 1))
				ini_write_real("mec_move", key_prefix_start+"_start",	round(_f_end))
				ini_write_real("mec_move", key_prefix_start+"_start_x", round(_start_poss[0]))
				ini_write_real("mec_move", key_prefix_start+"_start_y", round(_start_poss[1]))
				ini_write_real("mec_move", key_prefix_start+"_end_x",	round(_end_poss[0]))
				ini_write_real("mec_move", key_prefix_start+"_end_y",	round(_end_poss[1]))
				ini_close()
			}
			*/
			#endregion
		}
		//	criando o movimento inicial, que começa na posição da seta e termina no mesmo frame e na mesma posição
		ini_open(get_ini_name(_boss, 1))
		for(var s = 0; s < 4; s++){
			var p_prefix = get_ini_key_prefix(0, 0, s)
			var b_prefix = get_ini_key_prefix(1, 0, s)
			
			ini_write_real("mec_move", p_prefix+"_start", 0)
			ini_write_real("mec_move", p_prefix+"_start_x",	global.default_arrow_poss[s][0])
			ini_write_real("mec_move", p_prefix+"_start_y",	global.default_arrow_poss[s][1]) 
			ini_write_real("mec_move", p_prefix+"_end_x",	global.default_arrow_poss[s][0])
			ini_write_real("mec_move", p_prefix+"_end_y",	global.default_arrow_poss[s][1])
			
			ini_write_real("mec_move", b_prefix+"_start", 0)
			ini_write_real("mec_move", b_prefix+"_start_x",	room_width-global.default_arrow_poss[s][0])
			ini_write_real("mec_move", b_prefix+"_start_y",	global.default_arrow_poss[s][1]) 
			ini_write_real("mec_move", b_prefix+"_end_x",	room_width-global.default_arrow_poss[s][0])
			ini_write_real("mec_move", b_prefix+"_end_y",	global.default_arrow_poss[s][1])
		}
		ini_close()
		
		
	} // global.song_start_delay * 60
	global.boss_info[info_index.danob] = 50/qtd_arrows_boss
	global.boss_info[info_index.danop] = 50/qtd_arrows_player * 2
	
}


function get_ini_values(_player_or_boss, _frame, _seta){
	//var key_seta = get_ini_key_prefix(_player_or_boss, _frame, _seta)
	//var key_poison = get_ini_key_prefix(_player_or_boss, _frame, _seta)
	//var key_portal = get_ini_key_prefix(_player_or_boss, _frame, _seta)
	//var key_hold = get_ini_key_prefix(_player_or_boss, _frame, _seta)
	var key_prefix =  get_ini_key_prefix(_player_or_boss, _frame, _seta)
	
	//var key_seta = get_ini_key(ini_keys.arrow, _player_or_boss, _frame, _seta, noone)
	//var key_poison = get_ini_key(ini_keys.mec_bool, _player_or_boss, _frame, _seta, ini_mecs.poison)
	
	var s_atual			= ini_read_real("setas",		key_prefix,				noone)
	var s_hold_dur		= ini_read_real("mec_hold",		key_prefix + "_dur",	noone)
	var s_poison		= ini_read_real("mec_poison",	key_prefix,				noone)
	var s_portal_arrow	= ini_read_real("mec_portal",	key_prefix + "_arrow",	noone)
	var s_portal_offset	= ini_read_real("mec_portal",	key_prefix + "_offset", noone)
	var s_portal_delay	= ini_read_real("mec_portal",	key_prefix + "_delay",	noone)
	
	////show_message("dur: " + string(seta_hold_dur))
	
	return [s_atual, s_hold_dur, s_poison, s_portal_arrow, s_portal_offset, s_portal_delay];
}
function get_ini_move_values(_player_or_boss, _frame, _seta){
	////show_message(string(_player_or_boss) + " " + string(_frame) + " " + string(_seta))
	var key_prefix =  get_ini_key_prefix(_player_or_boss, _frame, _seta)
	////show_message(key_prefix)
	
	var seta_move_start = ini_read_real("mec_move", key_prefix + "_start", noone)
	var seta_move_start_x = ini_read_real("mec_move", key_prefix + "_start_x", noone)
	var seta_move_start_y = ini_read_real("mec_move", key_prefix + "_start_y", noone)
	var seta_move_end_x = ini_read_real("mec_move", key_prefix + "_end_x", noone)
	var seta_move_end_y = ini_read_real("mec_move", key_prefix + "_end_y", noone)
//	if (_frame == 0) //show_message("start: " + string(seta_move_start))
	
	var _values = [seta_move_start, seta_move_start_x, seta_move_start_y, seta_move_end_x, seta_move_end_y]
	if room == rmJoshua{
	//	if (_values[0] != noone or _values[3] != noone) show_message(string([_player_or_boss, key_prefix, _values]))
	}
	////show_message(_values)
	//if (_values[0] != -4){ ////show_message("prefix: " + string(key_prefix) + " get move values: " + string(_values))
		//if room == rmJoshua{
		//if _player_or_boss == 0 && _frame == 0 && _seta == 3{
		//	//show_message("move_values no 0: " + string(_values))
		//} else {
		//	//show_message(string(["move_values:", _player_or_boss, _frame, _seta]))
		//}
		//}
		return _values
		
		
	//}
}

function get_ini_name(_boss, _final_or_create){
	return string(string(_boss)+"_"+(_final_or_create == 0 ? "final" : "create"))
}


function ini_song_clear(){
	ini_section_delete("setas")
	ini_section_delete("mec_move")
	ini_section_delete("mec_poison")
	ini_section_delete("mec_poison")

}


function ini_find_move(_fhit, _arrow, _player_or_boss){
	_fhit = _fhit div 15 * 15
	var in_move = false; 
	var _f_check = _fhit;
	var poss = [[0, 0, 0],[0, 0, 0]] // inicio[x, y, frame], fim(x, y, frame)
	while(true){ // indo pra tras (checando fim ou inicio)
		//////show_message("seta: " + string(_arrow))
		var move_values	= get_ini_move_values(_player_or_boss, _f_check, _arrow);
		//show_message(string(["values find: ", _player_or_boss, _f_check, _arrow]))
		//if (_fhit == 102) //show_message("f: " + string(_f_check) + " start: " + string(move_values[ini_values_move.start]))
		if move_values[ini_values_move.start]{
			// start, x_start, y_start, x_close, y_close, close
			poss[0][2] = _f_check
			poss[1][2] = move_values[ini_values_move.start]
			poss[0][0] = move_values[ini_values_move.x_start]
			poss[0][1] = move_values[ini_values_move.y_start]
			var move_values_end = get_ini_move_values(_player_or_boss, move_values[ini_values_move.start], _arrow);
			poss[1][0] = move_values_end[ini_values_move.x_close]
			//show_message("voltando: achou o inicio")
			poss[1][1] = move_values_end[ini_values_move.y_close]
			////show_message("(achou o inicio indo pra tras) x final" + string(poss[1][0]) + "\n check_values: " + string(move_values) + "\n end_values: " + string(move_values_end))
			in_move = true
			//show_message("pra tras, achou inicio")
			break;
		}
		if move_values[ini_values_move.x_close]{	
			//////show_message(poss[0][0])
			//////show_message( move_values[ini_values_move.x_start])
			////show_message("voltando: achou o final")
			poss[0][0] = move_values[ini_values_move.x_close]
			poss[0][1] = move_values[ini_values_move.y_close]
			poss[0][2] = _f_check
			////show_message("achou o final indo pra tras (não definiu o xfinal), xstart: " + string(move_values[ini_values_move.x_start]) + " values: " + string(move_values))
						
						//show_message("pra tras, achou final " + string(_f_check))
			in_move = false;
			break;
		} 
		
		//show_message("fcheck pra tras: " + string(_f_check))
		if _f_check < 0{
			//show_message("pra tras, achou nada "+ string(_f_check))
			in_move = false
			break;
		}
		_f_check-=15;
	}

	////show_message("inmove: " + string(in_move) )
	if (!in_move){
		_f_check = _fhit;
		while(true){
			var move_values	= get_ini_move_values(_player_or_boss, _f_check, _arrow);
			if move_values[ini_values_move.start]{
				poss[1][0] = move_values[ini_values_move.x_start]
				////show_message("definiu o xfinal indo pra frente")
				poss[1][1] = move_values[ini_values_move.y_start]
				poss[1][2] = _f_check;
			}
			if _f_check >  global.boss_info[info_index.len] * 15{ 
				// não achou nada ent a posição final é a mesma da inicial
				poss[1][0] = poss[0][0]
				//////show_message("definiu xfinal pq acabou: " + string(poss[1][0]))
				poss[1][1] = poss[0][1]
				poss[1][2] = _f_check
				break;
			}
			_f_check+=15;
		}
	}
	//show_message(poss)
	//////show_message("xfinal: " + string(poss[1][0]))
	return poss;
}
