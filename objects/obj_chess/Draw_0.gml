/// @description draw board
//debug
//draw_text(5, 5, check[0]);
//draw_text(5, 20, check[1]);

//draw board
draw_sprite(boards[board_spr], 0, draw_x, draw_y);

//mouse highlight
if (!mouse_out && win==-1){
    //get board cell
    var _array, _type, _team;
    _array = board[# cell_x, cell_y];
    _team = _array[info.team];
    _type = _array[info.type];
    
    //draw mouse cell
    var _xx = draw_x + (cell_x*cell_size);
    var _yy = draw_y + (cell_y*cell_size);
    
    if (_team==turn){
        draw_highlight(_xx, _yy, cursor_color_team);
    }else{
        draw_highlight(_xx, _yy, cursor_color_simple);
    }
}

//draw check show
if (check_show){
    draw_highlight(checking_x, checking_y, check_color);
    draw_highlight(checked_x, checked_y, check_color);
}


//draw pieces
for(var h=0; h<board_h; h++){
    for(var w=0; w<board_w; w++){
        //get cell type
        var _arr = board[# w, h];
        var _type = _arr[info.type];
        var _team = _arr[info.team];
        //set position to draw cell in pixels
        var _xx = draw_x + (w*cell_size);
        var _yy = draw_y + (h*cell_size);
        //check if it is being moved
        var _moved = mode==2 && sel_x==w && sel_y==h;
        //draw moveable cells in move mode
        if (mode==1 && moveable[# w, h]){
            draw_highlight(_xx, _yy, moveable_color);
        }
        //draw selected
        if (mode==1 && sel_x==w && sel_y==h){
            draw_highlight(_xx, _yy, select_color);
        }
        //if not empty, draw piece
        if (_type!=type.empty && !_moved){
            draw_sprite_ext(sprites[_type], 0, _xx, _yy, 1, 1, 0, colors[_team], 1);
        }
    }
}

//draw move animation
if (mode==2){
    //move x/y
    var _move_px = draw_x + cell_size*move_x;
    var _move_py = draw_y + cell_size*move_y;
    
    //draw sprite
    draw_sprite_ext(sprites[sel_type], 0, anim_x, anim_y, 1, 1, 0, colors[turn], 1);
    
    //movement x/y
    //var _xx = _move_px - anim_x;
    //var _yy = _move_py - anim_y;
    
    //animate
    anim_x = lerp(anim_x, _move_px, anim_speed);
    anim_y = lerp(anim_y, _move_py, anim_speed);
    
    //set animated false
    if (point_distance(anim_x, anim_y, _move_px, _move_py)<=1) animated = true;
}

//draw lost pieces
var lost_size = 0.5;
var lost_draw_marg = cell_size * lost_size;

//0 team
for(var i=0; i<ds_list_size(lost[0]); i++){
    //get lost array
    var _list = lost[0];
    var _lost = _list[| i];
    var _lost_type = _lost[info.type];
    
    draw_sprite_ext(sprites[_lost_type], 0, draw_x - lost_draw_marg, draw_y + lost_draw_marg*i, lost_size, lost_size, 0, -1, 1);
}

//1 team
for(var i=0; i<ds_list_size(lost[1]); i++){
    //get lost array
    var _list = lost[1];
    var _lost = _list[| i];
    var _lost_type = _lost[info.type];
    
    draw_sprite_ext(sprites[_lost_type], 0, draw_x + cell_size*board_w, draw_y + lost_draw_marg*i, lost_size, lost_size, 0, c_black, 1);
}

//draw turn
var marg = 24;

if (win==-1){
    if (turn==0){
        draw_text_center(draw_x + (board_w*cell_size)/2, draw_y - marg, "White's Turn", 1, 1, 0, c_white, 1);
    }
    else if (turn==1){
        draw_text_center(draw_x + (board_w*cell_size)/2, draw_y + (board_h*cell_size) + marg, "Black's Turn", 1, 1, 0, c_black, 1);
    }
}

//draw won
if (win==0){
    draw_text_center(draw_x + (board_w*cell_size)/2, draw_y - marg, "White Won!", 1, 1, 0, c_white, 1);
}
else if (win==1){
    draw_text_center(draw_x + (board_w*cell_size)/2, draw_y + (board_h*cell_size) + marg, "Black Won!", 1, 1, 0, c_black, 1);
}

//draw check text
if (win==-1){
    if (check[0]){
        draw_text_center(draw_x + (board_w*cell_size)/2, draw_y - 8, "White is in check!", 0.7, 0.7, 0, c_white, 1);
    }
    else if (check[1]){
        draw_text_center(draw_x + (board_w*cell_size)/2, draw_y + (board_h*cell_size) + 8, "Black is in check!", 0.7, 0.7, 0, c_black, 1);
    }
}

//click to play again
if (win!=-1){
    draw_text_transformed(5, 5, string_hash_to_newline("Click to play again"), 0.7, 0.7, 0);
}

