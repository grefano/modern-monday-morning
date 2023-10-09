/// @description Insert description here
// You can write your code in this editor
song_to_chart = global.boss_info[2]
/*
bpm:
*/
bpm = 64;
batida_frames = room_speed*room_speed / bpm; // 60
/*
60fps
60 bpM -> 60/60 bpS -> 1 bpS
1 batida = fps / bps = 60 frame

60 fps
120 bpm -> 120/60 bpS -> 2 bpS
1 batida = fps / bps = 30 frame
*/

randomize()


gerar_setas(global.boss_info[1], 8, 0)

playing = true;
play_time = 0;
play_y = 0;

y_fourth = 0;