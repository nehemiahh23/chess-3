/// @description game
//exit if won
if (win!=-1){  
    //game restart on click
    if (mouse_check_button_pressed(mb_left)) room_restart();
    
    exit;
}

//mouse position
cell_x = (mouse_x - draw_x) div cell_size;
cell_y = (mouse_y - draw_y) div cell_size;

//mouse out of board
mouse_out = cell_x < 0 || cell_y < 0 || cell_x >= board_w || cell_y >= board_h;

//after animation complete
if (mode==2 && animated){
    //get move piece
    var _move_ar = board[# move_x, move_y];
    var _move_team = _move_ar[info.team];
    
    //defeat if enemy present
    if (_move_team==!turn) defeat_piece(move_x, move_y);
    
    //move piece
    board_set_cell(board, move_x, move_y, turn, sel_type);
    board_set_cell(board, sel_x, sel_y, -1, type.empty);
    
    //clear moveable grid after checking
    check[!turn] = false;
    moveable_check(moveable, move_x, move_y, board, sel_type);
    moveable_clear();
    
    //change turn
    turn = !turn;
    mode = 0;
    //if check, check if the other side is lost
    if (check[turn]){
        //vars to check their loss
        var can_be_defeated = false;
        var king_can_move = false;
        //apply all_moveable grid to check if the current piece can be defeated
        var all_moveable = ds_grid_create(board_w, board_h);
        for(var _h=0; _h<board_h; _h++){
            for(var _w=0; _w<board_w; _w++){
                //get array
                var _ar = board[# _w, _h];
                var _team = _ar[info.team];
                var _type = _ar[info.type];
                
                //check
                if (_team==turn){
                    moveable_check(all_moveable, _w, _h, board, _type);
                }
            }
        }
        //check if piece can be defeated
        can_be_defeated = all_moveable[# move_x, move_y];
        //destroy grid
        ds_grid_destroy(all_moveable);
        //--------check if king can move somewhere---------
        //get all possible moves of the opponent
        turn = !turn;
        
        all_moveable = ds_grid_create(board_w, board_h);
        
        var all_moveable = ds_grid_create(board_w, board_h);
        for(var _h=0; _h<board_h; _h++){
            for(var _w=0; _w<board_w; _w++){
                //get array
                var _ar = board[# _w, _h];
                var _team = _ar[info.team];
                var _type = _ar[info.type];
                
                //check
                if (_team==turn){
                    moveable_check(all_moveable, _w, _h, board, _type);
                }
            }
        }
        
        turn = !turn;
        
        //get king position
        var king_x = -1, king_y = -1;
        
        for(var _h=0; _h<board_h; _h++){
            for(var _w=0; _w<board_w; _w++){
                //get array
                var _ar = board[# _w, _h];
                var _team = _ar[info.team];
                var _type = _ar[info.type];
                
                if (_type==type.king && _team==turn){
                    king_x = _w;
                    king_y = _h;
                    break;
                }
            }
            if (king_x!=-1) break;
        }
        
        //loop through all 8 directional movements
        for(var _yy = -1; _yy <= 1; _yy++){
            for(var _xx = -1; _xx <= 1; _xx++){
                //check if out of bounds
                var out_bound = false;
                if (king_x+_xx < 0 || king_x+_xx >= board_w || king_y+_yy < 0 || king_y+_yy >= board_h) out_bound = true;
                if (!out_bound){
                    //if no one can move there
                    if (!all_moveable[# king_x + _xx, king_y + _yy]) king_can_move = true;
                    //if king can move there, check for friendly pieces
                    if (king_can_move){
                        //get array
                        var _ar = board[# king_x + _xx, king_y + _yy];
                        var _team = _ar[info.team];
                        var _type = _ar[info.type];
                        
                        if (_team==turn) king_can_move = false;
                        
                        //break if king can move
                        if (king_can_move) break;
                    }
                }
            }
            if (king_can_move) break;
        }
        
        //check if the player has any chances
        if (!king_can_move && !can_be_defeated){
            win = !turn;
            audio_play_sound(snd_win, 10, false);
            check_show = true;
        }
        
        //check
        check[turn] = true;
    }
}

//exit if mouse out of board
if (mouse_out) exit;

//get board cell
var _array, _type, _team;
_array = board[# cell_x, cell_y];
_team = _array[info.team];
_type = _array[info.type];

//if clicked
if (mouse_check_button_pressed(mb_left)){
    //select mode (0)
    if (mode==0 && _team==turn){
        //select piece
        sel_type = _type;
        sel_x = cell_x;
        sel_y = cell_y;
        mode = 1;
        
        //check moveables
        moveable_clear();
        moveable_check(moveable, sel_x, sel_y, board, sel_type);
        
        //sound
        audio_play_sound(snd_choose, 10, false);
    }
    //move mode (1)
    else if (mode==1){
        //check for checks from the other side
        check[turn] = false;
        
        //future board to know what is going to happen
        var future_board = ds_grid_create(board_w, board_h);
        ds_grid_copy(future_board, board);
        
        //move the piece in that board
        board_set_cell(future_board, sel_x, sel_y, -1, type.empty);
        board_set_cell(future_board, cell_x, cell_y, turn, sel_type);
        
        //check all pieces on opponent's team
        turn = !turn;
        for(var _h=0; _h<board_h; _h++){
            for(var _w=0; _w<board_w; _w++){
                //get array
                var _ar = future_board[# _w, _h];
                var _team = _ar[info.team];
                var _type = _ar[info.type];
                
                //check
                if (_team==turn){
                    var temp_grid = ds_grid_create(board_w, board_h);
                    moveable_check(temp_grid, _w, _h, future_board, _type);
                    ds_grid_destroy(temp_grid);
                }
                if (check[!turn]) break;
            }
            if (check[!turn]) break;
        }
        turn = !turn;
        
        ds_grid_destroy(future_board);
        //cancel move if check or if clicked on the same cell
        if ((cell_x==sel_x && cell_y==sel_y) || check[turn]){
            mode--;
            audio_play_sound(snd_cancel, 8, false);
            
            //show check if checked
            if (check[turn]){
                check_show = true;
                alarm[0] = 30;
            }
            
            //disable check
            check[turn] = false;
            
            //recheck check
            moveable_check(moveable, sel_x, sel_y, board, sel_type);
        }
        //register move
        else if (moveable[# cell_x, cell_y]){
            //set moving position
            move_x = cell_x;
            move_y = cell_y;
            
            //set animation position
            anim_x = draw_x + sel_x*cell_size;
            anim_y = draw_y + sel_y*cell_size;
            
            animated = false;
            
            //change mode
            mode = 2;
            
            //sound
            audio_play_sound(snd_move, 10, false);
            audio_play_sound(snd_drag, 8, false);
        }
    }
}