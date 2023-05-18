button_animate();

//change board
if (button_click() && image_alpha>0.9){
    obj_chess.board_spr++;
    
    //wrap
    var arr_len = array_length_1d(obj_chess.boards);
    
    if (obj_chess.board_spr >= arr_len) obj_chess.board_spr = 0;
    
    if (obj_chess.board_spr < 0) obj_chess.board_spr = arr_len - 1;
}

