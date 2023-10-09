/// @description Insert description here
// You can write your code in this editor

/*
- tela1
storymode - outra tela
freeplay - outra tela (vai ter a opção de mudar a chart)
options - outra tela
exit

*/
enum menu_actions{
	rodar_metodo,
	iniciar_menu
}
enum menus_lista{
	start,
	choose_boss,
	options
}
draw_menu = function(_menu){
	for(var i = 0; i < array_length(_menu); i++){
		draw_set_color(sel == i ? c_red : c_dkgray)
		set_text_align(5)
		
		var poss = [room_width*.5, 200+i*80]
		if (_menu[i][2] == menus_lista.start){
			set_text_align(1)
			poss[0] = 50
			poss[1] = room_height-80;	
		}
		draw_text(poss[0], poss[1], _menu[i][0]);
		
		draw_set_color(c_white)
	}
}
control_menu = function(_menu){
	sel += keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up);
	sel = clamp(sel, 0, array_length(_menu)-1)
	
	if keyboard_check_pressed(vk_enter){
		if _menu[sel][1] == menu_actions.iniciar_menu{
			// se a opção for pra mudar de menu
			menu_atual = _menu[sel][2];
		} else if _menu[sel][1] == menu_actions.rodar_metodo{
			// se a opção for pra executar um método
			//script_execute(_menu[sel][2]());
			_menu[sel][2]();
		}
		
	}
	if keyboard_check_pressed(vk_left){
		// mudar aquela chart
		if _menu[sel][2] == selm_chooseboss{
			selm_edit_song();
		}
	}
}

// sel método (oq ele faz qnd clica aquela opção)
selm_chooseboss = function(){
	room_goto(bosses[sel][0]);
}
selm_exit = function(){
	game_end();
}
selm_edit_song = function(){
	global.boss_info[1] = string( bosses[sel][1] ) + ".ini"
	room_goto(rmCharting);
}

menu_principal = [
					["Play",	menu_actions.iniciar_menu, menus_lista.choose_boss],
					["Options", menu_actions.iniciar_menu, menus_lista.options],
					["Exit",	menu_actions.rodar_metodo, selm_exit]
				 ]
menu_choose_boss = [
						["Boss1 rs",	menu_actions.rodar_metodo, selm_chooseboss],
						["Back",		menu_actions.iniciar_menu, menus_lista.start]
				   ]
menu_options = [
					["Teste1",	menu_actions.iniciar_menu, menus_lista.start],
					["Teste2",	menu_actions.iniciar_menu, menus_lista.start],
					["Back",	menu_actions.iniciar_menu, menus_lista.start]
			   ]
menus = [menu_principal, menu_choose_boss, menu_options]
bosses = [
			[rmGabriel, "boss1"]
		 ]// sala e .ini

menu_atual = menus_lista.start;
sel = 0;

sel_boss_y = room_height*.5;
