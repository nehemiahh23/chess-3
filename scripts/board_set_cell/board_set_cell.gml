/// @description  board_set_cell(board, x, y, team, type);
/// @param board
/// @param  x
/// @param  y
/// @param  team
/// @param  type
function board_set_cell(argument0, argument1, argument2, argument3, argument4) {
	var _arr;
	_arr[info.team] = argument3;
	_arr[info.type] = argument4;
	ds_grid_set(argument0, argument1, argument2, _arr);



}
