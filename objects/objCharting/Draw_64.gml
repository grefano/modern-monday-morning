/// @description Insert description here
// You can write your code in this editor




var chart_x = 100;
var chart_y = 0; // 100
var chart_w = 200;
var dist_batida = chart_w/4;
var qtd_fourth_height = ceil(room_height/dist_batida); // quantidade de batidas que devem ficar na chart
//var qtd_fourth_batidas = ceil((room_height-chart_y)/dist_batida);
var qtd_fourth_played = play_time/(batida_frames/4);

draw_rectangle(chart_x, chart_y, chart_x+chart_w, room_height, true)

// linhas horizontais
for(var i = max(y_fourth, 0)+round(qtd_fourth_played); i < y_fourth+ceil(qtd_fourth_height) + round(qtd_fourth_played); i++)
{
	// desenhando as linhas
	var y1 = chart_y+dist_batida*(i-qtd_fourth_played)
	var offsetx = (i%2 == 0 ? 0 : dist_batida/2) // se estiver no meio de uma batida
	// linha de divisão de cada subbatida
	draw_line_width(chart_x + offsetx, y1, chart_x+chart_w - offsetx, y1, 1)
	draw_text(chart_x + offsetx + 10, y1, i)
	// linha de divisão de cada batida
	if (i%4 == 0) draw_line_width(chart_x, y1,  chart_x+chart_w, y1, 3);
	
	// lendo as setas
	var time_to_read = i*15//string(i*(batida_frames/2))
	ini_open(global.boss_info[1])
	var seta = ini_read_real("setas", time_to_read, noone);
	ini_close()
	
	
	// desenhando as setas
	set_text_align(5)
	var yc = y1+dist_batida/2
	//draw_text(chart_x +chart_w - dist_batida/2 - seta * dist_batida , yc, time_to_read)
	if seta != noone{
		draw_sprite_ext(sprArrow, 0, chart_x +chart_w - dist_batida/2 - seta * dist_batida, yc, .25, .25, seta*90, global.arrows_colors[seta], 1)
	}
	set_text_align(1)
	

	
	// linha play
	play_y = chart_y + ( dist_batida )
	draw_line_color(chart_x, play_y, chart_x+chart_w, play_y, c_red, c_red)
	draw_text(chart_x + chart_w+10, play_y, play_time)
	
	
	
}
if mouse_check_button_pressed(mb_left){
	var arrow_to_set = (mouse_x-chart_x) / dist_batida;
	arrow_to_set = arrow_to_set - frac(arrow_to_set)
		
	var y_i0 = chart_y-dist_batida*qtd_fourth_played;
	//////show_message(y_i0)
}
// linha y_fourth (linha q desce e sobe a partir da "camera")
draw_circle(chart_x-12, chart_y + y_fourth*(dist_batida) + dist_batida/2, 5, false)

// linhas verticais
for(var i = 0; i < 4; i++){
	var seta_dist = chart_w/4;
	draw_line_width(chart_x+seta_dist*i, chart_y, chart_x+seta_dist*i, room_height, 1)
}