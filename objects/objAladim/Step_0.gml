/// @description Insert description here
// You can write your code in this editor



var song_speed = (global.boss_info[info_index.bpm]/fps)
var len_fourth = 60 / song_speed  // tempo em frames q a fourth dura
var _img_speed = sprite_get_number(sprite_index)/len_fourth

image_index += _img_speed;

//acx += 1/len_fourth       * 2
//if acx >= 1 acx = 0
//image_yscale = animcurve_channel_evaluate(animcurve_get_channel(acAladim, "idle_scl"), acx)
//image_xscale = 1-(1/image_yscale)
//if (keyboard_check_pressed(vk_enter)) game_set_speed(fps == 60 ? 20 : 60, gamespeed_fps)
//show_message(string([fps, fps_real]))