/// @description  cell_dist(dist_x, dist_y, cell_x, cell_y, sel_x, sel_y);
/// @param dist_x
/// @param  dist_y
/// @param  cell_x
/// @param  cell_y
/// @param  sel_x
/// @param  sel_y
function cell_dist(argument0, argument1, argument2, argument3, argument4, argument5) {

	var _x_d = argument0;
	var _y_d = argument1;

	var _x_c = argument2;
	var _y_c = argument3;
	var _x = argument4;
	var _y = argument5;

	if (_x + _x_d == _x_c && _y + _y_d == _y_c) return true; else return false;



}
