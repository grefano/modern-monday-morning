/// @description Insert description here
// You can write your code in this editor








var song_speed = (global.boss_info[info_index.bpm]/fps)
var len_fourth = 60 / song_speed  // tempo em frames q a fourth dura
var _img_speed = sprite_get_number(sprite_index)/len_fourth

image_index += _img_speed;