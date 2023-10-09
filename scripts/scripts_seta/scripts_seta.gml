// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro GRID_IMG  sprite_get_width(sprArrow)
#macro GRID_OFFSET frac(1280/GRID_IMG) * GRID_IMG / floor(1280/GRID_IMG) // .8 * 100 / 12 = ~7
#macro GRID_SIZE GRID_IMG/2 + GRID_OFFSET/2

global.default_arrows_ang = [180, 270, 90, 0]



enum boss_sprites {
	idle,
	right,
	up,
	down,
	left
}

function find_pos_move_grid(_xindex, _yindex){
	var _x = 0;
	var _y = 0;
	var distx = _xindex*(GRID_SIZE) 
	var disty = _yindex*(GRID_SIZE)
	//var distx = _xindex*(GRID_SIZE+GRID_OFFSET/2) 
	//var disty = _yindex*(GRID_SIZE+GRID_OFFSET/2)
	
	if _xindex < 0{
		//view
		_x = 1280 + distx;
		//////show_message("menor " + string(room_width) + " " + string(_x))
	} else {
		_x = distx
	}
	if _yindex < 0 {
		_y = 720 + disty
	} else {
		_y = disty
	}
	//////show_message([_x, _y])
	return [_x, _y]
}

//var ratio_spr_grid = GRID_IMG/GRID_SIZE; // sprw : 100    gridw : 50     ratio = 2
//var _arrow_offset = GRID_SIZE*ratio_spr_grid // 50 * 2 = 100    tamanho da seta + 1 grid
//var border = GRID_SIZE*2+GRID_OFFSET
//var dist = GRID_IMG+GRID_OFFSET

var _ydefault = find_pos_move_grid(0, 2)[1]
global.default_arrow_poss = [	[find_pos_move_grid(-8,0)[0], _ydefault],
								[find_pos_move_grid(-6,0)[0], _ydefault],
								[find_pos_move_grid(-4,0)[0], _ydefault],
								[find_pos_move_grid(-2,0)[0], _ydefault]	]	

function set_pos_in_move_grid(_x, _y){
	var _img = GRID_IMG
	var _size = GRID_SIZE
	var _ofs = GRID_OFFSET
	
	var index_x = _x div _size
	var index_y = _y div _size
	
	var xx = index_x * _size
	var yy = index_y * _size
	
	return [xx, yy]
}

function destroy_old_showhit(_arrowx, _arrowy){
	var near_showhit = instance_nearest(_arrowx, _arrowy-showhit_y,objShowHit);
	if near_showhit && near_showhit.x == _arrowx{
		instance_destroy(near_showhit)
	}
}

function check_press_arrow(_which_arrow){
	// sistema de apertar nos coiso
	
	//var seta = collision_rectangle(p_arrowfinal_pos[# _which_arrow, 0]-48, p_arrowfinal_pos[# _which_arrow, 1]-48,p_arrowfinal_pos[# _which_arrow, 0]+48, p_arrowfinal_pos[# _which_arrow, 1]+48,objSeta,true,true)
	var seta = noone;
	for(var i = 0; i < instance_number(objSeta); i++){
		var inst = instance_nearest(p_arrowfinal_pos[# _which_arrow, 0], p_arrowfinal_pos[# _which_arrow, 1], objSeta);
		if seta == noone or point_distance(p_arrowfinal_pos[# _which_arrow, 0], p_arrowfinal_pos[# _which_arrow, 1], inst.x, inst.y) < point_distance(p_arrowfinal_pos[# _which_arrow, 0], p_arrowfinal_pos[# _which_arrow, 1], seta.x, seta.y){
			seta = inst;
		}
	}
	
	if seta && !seta.pressed && seta.image_angle==global.default_arrows_ang[_which_arrow]{
		destroy_old_showhit(p_arrowfinal_pos[# _which_arrow, 0],p_arrowfinal_pos[# _which_arrow, 1])
		
		// definir 
		if (seta.inst_hold != noone){
			p_arrows_hold_insts[_which_arrow] = seta;
			
		}
		
		
		var dist = point_distance(p_arrowfinal_pos[# _which_arrow, 0], p_arrowfinal_pos[# _which_arrow, 1], seta.x, seta.y);
		var scor = medir_score(dist, global.hits_dist_score, ["SICK", "MEH", "GOOD", "BAD", "ERROR"])
		
		if dist > global.hits_dist_score[array_length(global.hits_dist_score)-1]{
			exit;	
		}
		
		#region	medindo score
		//var dist = point_distance(p_arrowfinal_pos[# _which_arrow, 0], p_arrowfinal_pos[# _which_arrow, 1], seta.x, seta.y);
		//var index_points = 3 // em q index ele vai adicionar o hit
		//var scor = "BAD"
		//if dist <= global.hits_dist_score[2]{
		//	scor = "MEH"
		//	index_points = 2
		//	if dist <= global.hits_dist_score[1]{
		//		scor = "GOOD"
		//		index_points = 1
		//		if dist <= global.hits_dist_score[0]{
		//			scor = "SICK"
		//			index_points = 0
		//		}
		//	}
		//}
		#endregion
		
		if seta.poisoned{
			points[3]++;
		} else {
			points[scor[1]]++;
			global.hp += global.boss_info[info_index.danop]
			
			// criando o showhit
			var s = instance_create_depth(p_arrowfinal_pos[# _which_arrow, 0],p_arrowfinal_pos[# _which_arrow, 1]-showhit_y, depth, objShowHit);
			s.txt = string(scor[0])
		}
		
		seta.pressed = true;
		seta.speed = 0;
		
		var sprite_array = [sprBFLeft, sprBFDown, sprBFUp, sprBFRight]
		objAladim.sprite_index = sprite_array[_which_arrow]
		objAladim.image_index = 0
		
		// AAAAQAA
	}
	//show_message(_which_arrow)
}

function gerar_setas(_boss, _qtd, _how_poison = .3){
	ini_open(get_ini_name(_boss, 0))
	ini_song_clear()


	for(var i = 0; i < _qtd; i++){
		var tempo = 30 * (i+irandom(2)) // 100 + 0   100 + 60   100 + 120    100 + 180	
		for(var s = 0; s < 3; s++){
			var seta = int64(irandom(3))
			seta-=frac(seta)
			ini_write_real("setas", string(tempo)+"_"+string(seta), (choose(11, 21)))
			ini_write_real("mecs_bool", string(tempo)+"_poison_"+string(seta), random(100) < _how_poison*100 ? 1 : 0)
			if (irandom(100) < 70) break;
		}
		
	}
	
	ini_close();

}

function instance_arrow(_fhit, _arrow, _ini_values, _player_or_boss){
	var p_poss = ini_find_move(_fhit, _arrow, _player_or_boss)
	var pos_create = [	transform_scale(p_poss[0][2], _fhit, p_poss[1][2],	p_poss[0][0], p_poss[1][0]),
						transform_scale(p_poss[0][2], _fhit, p_poss[1][2],	p_poss[0][1], p_poss[1][1]) + room_height]
	//show_message(p_poss)

	var i = instance_create_depth(pos_create[0], pos_create[1], depth, objSeta);
	i.image_angle = global.default_arrows_ang[_arrow];
	i.image_blend = global.arrows_colors[_arrow]
	i.vspeed = -_ini_values[ini_values.arrow]
	i.poisoned = _ini_values[ini_values.poison]
	
	return i;
}