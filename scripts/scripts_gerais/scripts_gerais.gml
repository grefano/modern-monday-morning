



function txt_percentage(_num, _max){
	var _txt = _num <= 0 ? 0 : int64(_num/_max*100)
	return string(_txt) + "%"
	//return string(_num) + "  " + string(_max)
	//return string(int64(_num/_max*100)) + "%"
}
function noone_to_text(_num){
	return _num == noone ? "0" : string(_num)
}
function set_text_align(_num = 1){
	var _h = (_num == 1 or _num == 4 or _num == 7) ? fa_left : ( (_num == 2 or _num == 5 or _num == 8) ? fa_middle : ((_num == 3 or _num == 6 or _num == 9) ? fa_right : fa_left)); 
	var _v = (_num == 1 or _num == 2 or _num == 3) ? fa_top : ( (_num == 4 or _num == 5 or _num == 6) ? fa_middle : ((_num == 7 or _num == 8 or _num == 9) ? fa_bottom : fa_top)); 
	
	draw_set_halign(_h)
	draw_set_valign(_v)
}

function approach(_from, _to, _how){
	if _from < _to{
		_from += _how;
		if (_from > _to)
			return _to
	} else{
		_from -= _how;
		if (_from < _to)
			return _to
	}
	return _from;
}

function add_hsv(_color, _h, _s, _v){
	return make_color_hsv(color_get_hue(_color)+_h, color_get_saturation(_color)+_s, color_get_value(_color)+_v)
}

function string_trim_zeroes(str){
	var l,r,o;
	r=1;
	
	l = 1;
	if string_pos(".",str) {
	  r = string_length(str);
	  repeat(r) {
	    o = ord(string_char_at(str,r));
	    if (o = 46) return string_copy(str,l,r-1);
	    if (o = 48) r -= 1;
	    else break;
	  }
	  str = string_copy(str,l,r);
	}
	repeat(r) {
	  o = ord(string_char_at(str,l));
	  if ((o > 8) && (o < 14) || (o == 32)) l += 1;
	  else break;
	}

	return string_copy(str,l,r-l+1);
}

function draw_bright(_w, _h, _o, _a){
	shader_set(shdTeste)


	var u_wh = shader_get_uniform(shdTeste, "wh");
	shader_set_uniform_f_array(u_wh, [_w,_h])
	var u_origin = shader_get_uniform(shdTeste, "origin");
	shader_set_uniform_f_array(u_origin, _o)
	var u_a = shader_get_uniform(shdTeste, "a_multi");
	shader_set_uniform_f(u_a, _a)

	draw_sprite_ext(sprBright, 0, _o[0], _o[1], _w/100, _h/100, 0, c_white, 1)
	shader_reset()


}

function control_draw_volume(_snd){
	draw_healthbar(room_width-120,20,room_width-20,40,global.volume*100, c_black, c_green, c_green, 0, true, true)
	global.volume = clamp(global.volume+(keyboard_check_pressed(vk_add)-keyboard_check_pressed(vk_subtract))*.1, 0, 1)
	audio_sound_gain(_snd, global.volume, 100)
}

function control_value_tab(_xleft, _ytop, _sec, _key, _min, _max, _segw, _sepb, _name, _pass= 1){
	var value = ini_read_real(_sec, _key, noone)
	var sep = 10;
	var name_h = string_height(_name) * tab_values_size
	var tri_w = 10
	
	draw_set_valign(fa_top)
	
	var name_w = string_width(_name) * tab_values_size
	var value_w = string_width(value) * tab_values_size
	
	
	//		NAME
	draw_set_halign(fa_left)
	draw_text_transformed(_xleft + _sepb, _ytop, _name, tab_values_size, tab_values_size, 0)
		
	
	if !(_max == 1 && _min == 0){ // tipo de valor é inteiro e não boolean
		
		
		
		
		draw_set_halign(fa_middle)
		
		//		RESET
		var colors_reset = [merge_color($003FFF, c_white, .1), merge_color($4343B3, c_white, .1)]
		
		var reset_w = 24;
		//var reset_mx = _xleft + name_w + 4*sep + 2*tri_w + value_w + reset_w/2
		var reset_mx = _xleft + _segw - _sepb - reset_w/2
		draw_rectangle_color(reset_mx-reset_w/2, _ytop , reset_mx+reset_w/2, _ytop+name_h, colors_reset[0], colors_reset[1], colors_reset[0], colors_reset[1], false)
		
		draw_text_transformed(reset_mx, _ytop, "r", tab_values_size, tab_values_size, 0)
		
		//		SETAS
		var value_mx = ( (reset_mx-reset_w/2)+(_xleft+_sepb+name_w) ) / 2
		var l_tri_x = value_mx - value_w/2 - tri_w - sep/2
		draw_triangle(l_tri_x, _ytop+name_h/2,		l_tri_x + tri_w, _ytop,		l_tri_x + tri_w, _ytop + name_h,	false)
		var r_tri_x = value_mx + value_w/2 + tri_w + sep/2
		draw_triangle(r_tri_x, _ytop+name_h/2,		r_tri_x - tri_w, _ytop,		r_tri_x - tri_w, _ytop + name_h, false)
		

		draw_text_transformed(( l_tri_x + r_tri_x )/2, _ytop, value, tab_values_size, tab_values_size, 0)

		//draw_rectangle(_xmid, _ytop, _xmid-40, _ytop+th, true)
		if mouse_check_button_pressed(mb_left){
			if point_in_rectangle(mouse_x, mouse_y, l_tri_x, _ytop, l_tri_x+tri_w, _ytop+name_h){
				// mouse na seta esquerda
				var value_set = value-_pass
				if value_set < _min && _min != noone{
					ini_key_delete(_sec, _key)
				} else {
					value_set = _min != noone ? max(value_set, _min) : value_set;
					value_set = _max != noone ? min(value_set, _max) : value_set
			
					if value == noone{
						ini_write_real(_sec, _key, _min == noone ? -_pass : _min)
					} else {
						ini_write_real(_sec, _key, value_set)
					}
					ini_write_real(_sec, _key, value_set)
				}
				//////show_message("ayo")
			
			} else if point_in_rectangle(mouse_x, mouse_y, r_tri_x-tri_w, _ytop, r_tri_x, _ytop+name_h){
				// mouse na seta direita
				var value_set = value+_pass
				if value_set > _max && _max != noone{
					ini_key_delete(_sec, _key)
				} else {
					value_set = _min != noone ? max(value_set, _min) : value_set;
					value_set = _max != noone ? min(value_set, _max) : value_set
			
					if value == noone{
						ini_write_real(_sec, _key, _min == noone ? _pass : _min)
					} else {
						ini_write_real(_sec, _key, value_set)
					}
				}
				//////show_message(value_set)
			}
			// se quiser ir pra um valar menor q o minimo, apaga a key
			// se a key nao existir, cria ela com o numero minimo
		
		
		
			if point_in_rectangle(mouse_x, mouse_y, reset_mx-reset_w/2, _ytop, reset_mx+reset_w/2, _ytop+name_h){
				ini_key_delete(_sec, _key)
			}
		}
		
	} else {
		// tipo de valor é bool
		draw_set_halign(fa_middle)
		
		
		
		var bool_x = _xleft + _sepb + name_w + 2*sep + tri_w + value_w/2
		draw_rectangle(bool_x-30, _ytop, bool_x+30, _ytop+name_h, true);
		draw_text_transformed(bool_x, _ytop, value ? "real" : "fake", tab_values_size, tab_values_size, 0)
		
		if mouse_check_button_pressed(mb_left){
			if point_in_rectangle(mouse_x, mouse_y, bool_x-30, _ytop, bool_x+30, _ytop+name_h){
				if value{
					foreach_delete_key_sel_seta(_sec, _key)
				} else {
					foreach_write_key_sel_seta(_sec, _key, 1)
				}
			}
		}
	}
}
/*

function control_value_tab(_xmid, _ytop, _sec, _key, _min, _max, _tabw, _name){
	var value = ini_read_real(_sec, _key, noone)
	var txt_size = tab_values_size;
	var sepx = 10;
	var _xc_value = _xmid-sepx
	var _xc_reset = _xmid+sepx;
	
	var th = string_height(value)*txt_size
	
	draw_set_halign(fa_middle)
	draw_set_valign(fa_top)

	
	if !(_max == 1 && _min == 0){ // tipo de valor é inteiro e não boolean
		//		SETAS
		//draw_set_halign(fa_middle)
		draw_text_transformed(_xmid, _ytop, value, txt_size, txt_size, 0);
		var seta_w = 13;
		draw_triangle(_xmid - th, _ytop + th/2,		_xmid - seta_w, _ytop,		_xmid - seta_w, _ytop+th, false)
		draw_triangle(_xmid + th, _ytop + th/2,		_xmid + seta_w, _ytop,		_xmid + seta_w, _ytop+th, false)
		
		//		NAME
		draw_text_transformed(_xmid - th - seta_w - sepx, _ytop, "", txt_size, txt_size, 0)
		
		//		RESET
		//var colors_button_reset = [merge_color(c_red, c_white, .5), merge_color(c_red, c_dkgray, .5)];
		//var reset_ytop = _ytop;
		var colors_reset = [merge_color($003FFF, c_white, .1), merge_color($4343B3, c_white, .1)]
		var reset_w = 30;
		var reset_mx = _xmid + th + seta_w + sepx
		draw_rectangle_color( reset_mx - reset_w/2,_ytop, reset_mx + reset_w/2,_ytop+th, colors_reset[0], colors_reset[1], colors_reset[0], colors_reset[1], false)
		draw_text_transformed(reset_mx, _ytop, "r", txt_size, txt_size, 0);
		

		//draw_rectangle(_xmid, _ytop, _xmid-40, _ytop+th, true)
		if mouse_check_button_pressed(mb_left){
			if point_in_rectangle(mouse_x, mouse_y, _xc_value-th*2, _ytop, _xc_value, _ytop+th){
				// mouse na seta esquerda
				var value_set = value-1
				if value_set < _min && _min != noone{
					ini_key_delete(_sec, _key)
				} else {
					value_set = _min != noone ? max(value_set, _min) : value_set;
					value_set = _max != noone ? min(value_set, _max) : value_set
			
					if value == noone{
						ini_write_real(_sec, _key, _min)
					} else {
						ini_write_real(_sec, _key, value_set)
					}
					ini_write_real(_sec, _key, value_set)
				}
				//////show_message("ayo")
			
			} else if point_in_rectangle(mouse_x, mouse_y, _xc_value, _ytop, _xc_value+th*2, _ytop+th){
				// mouse na seta direita
				var value_set = value+1
				if value_set > _max && _max != noone{
					ini_key_delete(_sec, _key)
				} else {
					value_set = _min != noone ? max(value_set, _min) : value_set;
					value_set = _max != noone ? min(value_set, _max) : value_set
			
					if value == noone{
						ini_write_real(_sec, _key, _min)
					} else {
						ini_write_real(_sec, _key, value_set)
					}
				}
				//////show_message(value_set)
			}
			// se quiser ir pra um valar menor q o minimo, apaga a key
			// se a key nao existir, cria ela com o numero minimo
		
		
		
			if point_in_rectangle(mouse_x, mouse_y, _xc_reset-30, _ytop, _xc_reset+30,_ytop+th){
				ini_key_delete(_sec, _key)
			}
		}
		
	} else {
		// tipo de valor é bool
		draw_rectangle(_xmid-30, _ytop, _xmid+30, _ytop+th, true);
		draw_text_transformed(_xmid, _ytop, value ? "real" : "fake", txt_size, txt_size, 0)
		if mouse_check_button_pressed(mb_left){
			if point_in_rectangle(mouse_x, mouse_y, _xmid-30, _ytop, _xmid+30, _ytop+th){
				if value{
					ini_key_delete(_sec, _key)
				} else {
					ini_write_real(_sec, _key, 1)
				}
			}
		}
	}
}
*/

function transform_scale(_fstart, _fhit, _fend,		_posstart, _posend){
	var diff_fend = _fend-_fstart
	var diff_fhit = _fhit-_fstart
	var diff_pend = _posend-_posstart
	// diffhit/diffend = x-postart/diffpend
	// x = diffhit/diffend * diffpend + postart
	return diff_fhit/diff_fend * diff_pend + _posstart
}
//////show_message(transform_scale(120, 120, 180, 1226, 903))
function medir_score(_dist, array_score_values, array_score_names){
	var qtd_scores = array_length(array_score_names) // 4
	var index_points = qtd_scores-1; // 3
	var scor = array_score_names[index_points] // [sick, good, meh, bad] -> bad
	for(var i = qtd_scores-2; i >= 0; i--){ // i = 2; i > 0; i--
		if _dist <= array_score_values[i]{ // 40 <= i (2, 1, 0) // out of range
			scor = array_score_names[i] // scor = []
			index_points = i
		}
	}
	return [scor, index_points]
}
//show_debug_message("ayo" + string(medir_score(40, [15, 30, 45], ["sick", "good", "meh", "bad"])))
function freeze(_t, _ctime){
	while current_time < _ctime + _t{}
}

//enum debug_types_index{
//	seta_poss
//}
//global.debug_types_names = [];
//ds_list
//
//global.add_
//
//function show_msg(type, msg) {
//	var add = 10;
//    if ((add & type) == type) {
//        show_message("Mensagem de Debug:" + string(msg));
//    } else {
//       show_message("Tipo não está contido em " + string(add));
//    }
//}
//show_msg(1, "1")
//show_msg(2, "2")
//show_msg(4, "4")
//show_msg(8, "8")
//show_msg(16, "16")
//show_msg(32, "32")