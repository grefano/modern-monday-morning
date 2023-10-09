global.part_sys = part_system_create();
global.ptype_arrow_poison = part_type_create()

part_type_size(		global.ptype_arrow_poison, .5, .7, 0, 0)
part_type_alpha3(	global.ptype_arrow_poison, 0, 1, 0)
part_type_color1(	global.ptype_arrow_poison, c_black)
part_type_direction(global.ptype_arrow_poison, 70, 110, 0, 0)
part_type_speed(	global.ptype_arrow_poison, 2, 4, -.05, 0)
part_type_shape(	global.ptype_arrow_poison, pt_shape_sphere);
part_type_life(		global.ptype_arrow_poison, 10, 30)


global.ptype_arrow_press_cloud = part_type_create();

part_type_size(		global.ptype_arrow_press_cloud, 2, 2, 0, 0)
part_type_alpha1(	global.ptype_arrow_press_cloud, .25)
part_type_orientation(global.ptype_arrow_press_cloud, 0, 360, 0, 5, 0)
part_type_color1(	global.ptype_arrow_press_cloud, c_white)
part_type_direction(global.ptype_arrow_press_cloud, 0, 0, 0, 0)
part_type_shape(	global.ptype_arrow_press_cloud, pt_shape_cloud);
part_type_life(		global.ptype_arrow_press_cloud, 5, 5)


global.ptype_arrow_press_flare = part_type_create();

part_type_size(		global.ptype_arrow_press_flare, .5, 2, 0, 0)
part_type_orientation(global.ptype_arrow_press_flare, 0, 360, 0, 5, 0)
part_type_alpha2(	global.ptype_arrow_press_flare, 1, 0)
part_type_color1(	global.ptype_arrow_press_flare, c_white)
//part_type_speed(	global.ptype_arrow_press_flare, .2, .5, -.1, 0)
part_type_shape(	global.ptype_arrow_press_flare, pt_shape_spark);
part_type_life(		global.ptype_arrow_press_flare, 5, 5)