/// @description Insert description here
// You can write your code in this editor
if debug_show {
	var golden = 1.618
	draw_set_color(c_yellow)
	draw_line(room_width/golden, 0, room_width/golden, room_height)
	draw_line(room_width-room_width/golden, 0, room_width-room_width/golden, room_height)
	draw_line(0, room_height/golden, room_width, room_height/golden)
	draw_line(0, room_height-room_height/golden, room_width, room_height-room_height/golden)

	draw_set_color(c_red)
	draw_line(room_width*.333, 0, room_width*.333, room_height)
	draw_line(room_width*.666, 0, room_width*.666, room_height)
	draw_line(0, room_height*.333, room_width, room_height*.333)
	draw_line(0, room_height*.666, room_width, room_height*.666)

	draw_set_color(c_white)

	
	draw_text(40,100, global.frame)
	draw_text(40,120, string(p_arrows_hold))
	//draw_text(40,120, string(px_hold_fx[0]) + " " + string(px_hold_fx[1]) + " " + string(px_hold_fx[2]) + " " + string(px_hold_fx[3]))
	

	draw_rectangle(p_arrowfinal_pos[# 0, 0]-48, p_arrowfinal_pos[# 0, 1]-48,p_arrowfinal_pos[# 0, 0]+48, p_arrowfinal_pos[# 0, 1]+48, true)
	
	draw_healthbar(50, room_height-80, room_width-50, room_height-50, global.hp, c_black, c_red, c_red, 0, 1, 1)
	draw_text(room_width/2, room_height-40, global.hp)
	
}

draw_final_arrows();

ini_open(get_ini_name(global.boss_info[info_index.name], 1))


var key_spin_start = ini_read_real("spin", get_ini_key_prefix(1, global.frame) + "_start", noone)
if key_spin_start{
		
}

////show_message(get_ini_name(global.boss_info[1], 1))
if debug_show{
for(var i = 0; i < 4; i++){
	var p_prefix = get_ini_key_prefix(0, 0, i)
	var xx = ini_read_real("mec_move", p_prefix+"_start_x", noone)
	var yy = ini_read_real("mec_move", p_prefix+"_start_y", noone)
	draw_circle_color(xx, yy, 5, c_red, c_red, true)
	
	var b_prefix = get_ini_key_prefix(1, 0, i)
	var xx = ini_read_real("mec_move", b_prefix+"_start_x", noone)
	var yy = ini_read_real("mec_move", b_prefix+"_start_y", noone)
	draw_circle_color(xx, yy, 5, c_purple, c_purple, true)
}
}

// criando setas
for(var s = 0; s < 4; s++){
	var rframe = round(global.frame)
	
	create_arrow(0, rframe, s)
	//create_arrow(1, rframe, s)
	
	
	var arrows_values_boss = get_ini_values(1, rframe, s)
	if arrows_values_boss[ini_values.arrow] != noone{
		objBoss.sprite_index = objBoss.sprites[s+1]
		//show_message(string([s, sprite_get_name(objBoss.sprites[s+1])]))
		objBoss.image_index = 0
		global.hp -= global.boss_info[info_index.danob]
		//show_message(s)
	}
	
	//show_message(get_ini_move_values(1, 0, 0))
	
	#region
	/*
	//if player_values[ini_values.arrow] != noone{ // se tem seta
	//	////show_message("player tem omg")
	//	var p_poss = ini_find_move(rframe_hit, s, 0)
	//	var pos_hit = [rframe_hit*p_poss[0][0]/p_poss[0][2], rframe_hit*p_poss[0][1]/p_poss[0][2]]
	//	var pos_create = [pos_hit[0], pos_hit[1]+room_height]
	//	
	
		//			procurando inicio e fim do movimento
		
		p_frames_move = [[noone, noone], [noone, noone], [noone, noone], [noone, noone]]; // start, end
		var _f_check = rframe_hit;
		var poss_move = [[noone, noone], [noone, noone]] // start[x, y], end[x, y]
		while(true){
			
			var player_move_values	= get_ini_move_values(0, _f_check, s);
			var boss_move_values	= get_ini_move_values(1, _f_check, s);
			
			if (player_move_values[ini_values_move.start]){
				p_frames_move[s][0] = _f_check;
				poss_move[0] = [player_move_values[ini_values_move.x_start], player_move_values[ini_values_move.y_start]] 
			}
			if (player_move_values[ini_values_move.close]){
				p_frames_move[s][1] = _f_check;
				poss_move[1] = [player_move_values[ini_values_move.x_close], player_move_values[ini_values_move.y_close]]
			}
			if p_frames_move[s][0] != noone && p_frames_move[s][1] != noone{
				// achou o inicio e o fim do movimento
				break
			}
			
			if p_frames_move[s][0] != noone && p_frames_move[s][1] == noone{ 	// achou o inicio e o final não, ou seja, ta no meio de um movimento
				p_frames_move[s][1] = player_move_values[ini_values_move.start];
			} else { // se não estiver no meio de um movimento, procurar o proximo inicio (pra achar o fim)
				var _f_check_next_start = rframe_hit;
				while(true){
					//show_debug_message(random(3))
					var player_move_values = get_ini_move_values(0,_f_check_next_start, s);
					var boss_move_values = get_ini_move_values(1, _f_check_next_start, s);
					
					if player_move_values[ini_values_move.start]{
						var movex = (poss_move[1][0]*_f_check_next_start)/p_frames_move[s][1]
						
						//			x fim do movimento anterior * _f_check_next_start / frame final movimento anterior
						var movey = (poss_move[1][1]*_f_check_next_start)/p_frames_move[s][1]
						if movex != noone{
							show_debug_message("frame: " + string(_f_check_next_start) + " y next start:" + string(movey))
							break
						};
					}
					if _f_check_next_start >= global.boss_info[info_index.len]*15{
						// nao achou o proximo inicio
						//show_message("n achou")
						break;
					}
					
					//if player_move_values[ini_values_move.start]{ // achou o proximo inicio
					//	
					//	// regra de 3 simples pra ver a posição do frame q ta prevendo (com base no frame de inicio e na posição)
					//	var movex = (player_move_values[ini_values_move.x_start]*_f_check_next_start)/p_frames_move[s][0]
					//	var movey = (player_move_values[ini_values_move.y_start]*_f_check_next_start)/p_frames_move[s][0]
					//	p_arrowfinal_pos_now[s][0] = movex 
					//	p_arrowfinal_pos_now[s][1] = movey
					//}
					
					_f_check_next_start += 15;
				}
			}
			//if p_frames_move[s][0] != noone && p_frames_move[s][1] == noone{ 	// achou o inicio e o final não
			//	// achar o final
			//	var _f_check_only_end = rframe
			//	while(true){
			//		var player_move_values = get_ini_move_values(0,_f_check, s);
			//		if player_move_values[ini_values_move.move_end]{ // achar o final
			//			p_frames_move[s][1] = player_move_values[ini_values_move.move_end]
			//			return;
			//		}
			//		_f_check_only_end+=15;
			//	}
			//}
			
			_f_check-=15;
		}
	//	// criando a instancia
	//	var yy = room_height + (p_arrowfinal_pos[# s, 1]					- arrow_final_miny)
	//	//var yy = room_height + (p_arrowfinal_pos[# s, 1]					- arrow_final_miny)    // h + ysetafinal
	//	var i = instance_create_depth(pos_create[0], pos_create[1], depth, objSeta);
	//	i.image_angle = s*90;
	//	i.image_blend = global.arrows_colors[s]
	//	i.vspeed = -player_values[ini_values.arrow]
	//	i.poisoned = player_values[ini_values.poison]
	//	////show_message("inst: " + string(i) + " vspd: " + string(-player_values[ini_values.arrow]) + " yy: " + string(yy))
	//	////show_message(poss_move)
	//}
	*/
	#endregion
	//		pathing
	if p_pathing_frames[1]{
		var prefix_pathing_start = get_ini_key_prefix(0, p_pathing_frames[0], pathing_arrow_sel[0]);
		var prefix_pathing_end	 = get_ini_key_prefix(0, p_pathing_frames[1], pathing_arrow_sel[0]);
		
		var pathing_start_poss	= [ini_read_real("mec_move", prefix_pathing_start+"_start_x", noone), ini_read_real("mec_move", prefix_pathing_start+"_start_y", noone)]
		//show_debug_message(pathing_start_poss)
	//	var pathing_end_poss	= [ini_read_real("mec_move", prefix_pathing_end  +"_end_x"  , noone), ini_read_real("mec_move", prefix_pathing_end  +"_end_y", noone)]
		draw_line_width(pathing_start_poss[0], pathing_start_poss[1], mouse_x, mouse_y, 5)
		draw_text(20,500,"start poss: " + string(pathing_start_poss)) //  + " end poss: " + string(pathing_end_poss)
		draw_text(20,520,"pathing arrow sel: " + string(pathing_arrow_sel[0]))
	}
		//		movimentando as setas finais
	var p_move_values_now = get_ini_move_values(0, rframe, s);
//	//show_message(rframe)
	if p_move_values_now[ini_values_move.start] != noone{
		var p_move_values_final = get_ini_move_values(0, p_move_values_now[ini_values_move.start], s);
		// começar movimento
		//var postox = (p_arrowfinal_pos[# s, 0] * p_move_values_now[ini_values_move.start])/rframe
		//var postoy = (p_arrowfinal_pos[# s, 1] * p_move_values_now[ini_values_move.start])/rframe
		var poss = [p_arrowfinal_pos[# s, 0], p_arrowfinal_pos[# s, 1], p_move_values_final[ini_values_move.x_close], p_move_values_final[ini_values_move.y_close]]
		var dir = point_direction(poss[0], poss[1], poss[2], poss[3])
		var dist = point_distance(poss[0], poss[1], poss[2], poss[3])
		var spd = dist/(p_move_values_now[ini_values_move.start]-rframe)
		p_arrowfinal_pos[# s, 2] = spd;
		p_arrowfinal_pos[# s, 3] = dir;


		//			x fim do movimento anterior * _f_check_next_start / frame final movimento anterior
	} else if p_move_values_now[ini_values_move.x_close]{
		p_arrowfinal_pos[# s, 2] = 0;
		//p_arrowfinal_pos[# s, 3] = dir;
	}
}

ini_close();

#region miniplayer
var panelw = room_width*.15;
var panelh = room_height*.15;
var panelpos = [mouse_x, mouse_y] // 50
draw_rectangle(panelpos[0],panelpos[1],panelpos[0]+panelw,panelpos[1]+panelh,true)

for(var i = 0; i < instance_number(objSeta); i++){
	var radius = (sprite_get_width(sprArrow)/room_width) * panelw / 2
	var inst = instance_find(objSeta, i)
	var rate = [inst.x / room_width, inst.y / room_height];
	
	draw_set_color(inst.poisoned ? c_black : inst.image_blend)
	draw_circle(panelpos[0] + (panelw * rate[0]), panelpos[1] + (panelh * rate[1]), radius, false)
	draw_set_color(c_black)
	draw_circle(panelpos[0] + (panelw * rate[0]), panelpos[1] + (panelh * rate[1]), radius, true)
	draw_set_color(-1)
}

for(var i = 0; i<4;i++){
	var xx = panelpos[0] +		p_arrowfinal_pos[# i, 0]/room_width*panelw;
	var yy = panelpos[1] +		p_arrowfinal_pos[# i, 1]/room_height*panelh;
	draw_circle(xx, yy, 5, true)
}


#endregion

#region pontuação
set_text_align(7)
var total_setas = points[0]+points[1]+points[2]+points[3]+points[4]
var scor = points[0]+points[1]*.75+points[2]*.50+points[3]*.25

draw_text(panelpos[0],panelpos[1],"SICK: " +txt_percentage(points[0], total_setas) + "  " +
								"GOOD: " +	txt_percentage(points[1], total_setas) + "  " +
								"MEH: " +	txt_percentage(points[2], total_setas) + "  " +
								"BAD: " +	txt_percentage(points[3], total_setas) + "  " +
								"ERROR: " + txt_percentage(points[4], total_setas))


if scor == 0{
	var letter_score = "D"
} else if scor == total_setas{
	var letter_score = "S"
} else if scor > 0{
	var letter_score = "D"
	if scor > total_setas*.25{
		var letter_score = "C"
		if scor > total_setas*.5{
			var letter_score = "B"
			if scor > total_setas*.75{
				var letter_score = "A"
			}
		}
	}
}
draw_set_font(fntScore)
set_text_align(5)

draw_set_color(c_black)
draw_text(room_width*.33,205,letter_score)
draw_set_color(c_white)
draw_text(room_width*.33,200,letter_score)
//draw_text(50,250,string(int64(max(scor/total_setas*100, 0)))+"%")
draw_text_transformed(room_width*.33,250,string(txt_percentage(scor, total_setas)), .35, .35, 0)

set_text_align(1)
draw_set_font(-1)
#endregion

if debug_show{

draw_text(20,160,"time: " + string(time))
draw_text(20,180,"frame: " + string(global.frame))
draw_text(20,200,"index: " + string(index_check))
draw_text(20,220,"pathframes: " + string(p_pathing_frames))
}

control_draw_volume(global.boss_info[info_index.snd])

//		desenhando grid
if p_pathing_frames[0]{
	var _img = GRID_IMG
	var _size = GRID_SIZE
	var _ofs = GRID_OFFSET
	
	var s_poss = set_pos_in_move_grid(mouse_x, mouse_y)
	
	
	/*
	var grid_posx = mouse_x div GRID_IMG;
	var grid_posy = mouse_y div GRID_IMG
	var repair_offset = GRID_IMG * 0
	var _xs = (mouse_x-repair_offset) div (GRID_SIZE+GRID_OFFSET) * GRID_SIZE + grid_posx*GRID_OFFSET
	var _ys = (mouse_y-repair_offset) div (GRID_SIZE+GRID_OFFSET) * GRID_SIZE + grid_posy*GRID_OFFSET
	*/
	draw_rectangle(s_poss[0], s_poss[1], s_poss[0]+_img, s_poss[1]+_img, true)
	
	draw_set_alpha(.2)
	for(var i = 0; i < 12; i++){
		var xl = _img * i + _ofs * i
		draw_line(xl, 0, xl, 720)
		draw_line(xl+_img, 0, xl+_img, 720)
	}
	for(var l = 0; l < floor(720 / _img); l++){
		var yl = _img * l + _ofs * l
		draw_line(0, yl, 1280, yl)
		draw_line(0, yl+_img, 1280, yl+_img)
	}
	draw_set_alpha(1)
} 



