/// @description Insert description here
// You can write your code in this editor
draw_set_font(fntScore)
draw_set_halign(fa_middle)
draw_set_valign(fa_middle)

var size = animcurve_channel_evaluate(animcurve_get_channel(acShowHit, "size"), acx);

draw_set_color(c_black)
draw_text_transformed(x,y-1,txt, size*2 *.33, size*2*.33, 0)
draw_set_color(-1)
draw_text_transformed(x,y,txt, size*2 *.3, size*2*.3, 0)
//raw_text_transformed(x,y,txt, 2, 2, 0)


acx+=.02;
draw_set_font(-1)