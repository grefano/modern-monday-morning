/// @description Insert description here
// You can write your code in this editor


//var line_ang = 55;
//for(var i = 0; i < 12; i++){
//	var camh = camera_get_view_height(view_camera[0])
//	var xx = i*(1280/12)
//	var yy = 720/2
//	var xadd_ang = lengthdir_x(700, line_ang)-xx
//	
//	var width_max = 50;
//	var width_sub = abs(i-(12/2))/(12/2)
//	//var yadd_ang = lengthdir_y(700, 2)-yy
//	draw_line_width(xx-xadd_ang, 0, xx+xadd_ang, camh, width_max-width_sub)
//}

//for(var i = 0; i < 8; i++){
//	var radius = 50 - (clamp(acx - i/2, 0, 1)*50)
//	//draw_circle(100+i*150,360, radius, false)
//	draw_text_transformed(100+i*150,360, radius, 1, radius/25, 0)
//}
draw_text(50,50,acx)
var qtd = 20;
var w = 200;
for(var i = 0; i < qtd; i++){
	room_goto(room_to)
	instance_destroy()
	var xc = view_wport[0]/2 + w * (i-qtd/2)
	var yc = view_hport[0]/2;
	var ang = 45;
	var len = 600;
	draw_line_width(xc + lengthdir_x(len, ang), yc + lengthdir_y(len, ang), xc + lengthdir_x(len, 270-ang), yc + lengthdir_y(len, 270-ang), 50 - abs(i-acx*qtd)*5)
}

var _alpha = animcurve_channel_evaluate(animcurve_get_channel(acTransition, "alpha"), acx)
if _alpha >= 1{
	room_goto(room_to)
}
if acx >= 1{instance_destroy()}

draw_set_color(c_white)
draw_set_alpha(0);
draw_rectangle(0, 0, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]), false)
draw_set_alpha(1)

