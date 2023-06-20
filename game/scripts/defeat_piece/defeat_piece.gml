/// @description  defeat_piece(x, y);
/// @param x
/// @param  y
function defeat_piece(argument0, argument1) {
	//add to lost ds list
	var _piece_arr = board[# argument0, argument1];
	ds_list_add(lost[!turn], array_new(_piece_arr));



}
