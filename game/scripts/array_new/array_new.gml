/// @description  array_new(array_to_copy)
function array_new(argument0) {
	//copies an array and returns the copy
	var new_array;

	for(var i=0; i<array_length_1d(argument0); i++){
	    new_array[i] = argument0[i];
	}

	return new_array;



}
