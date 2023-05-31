/// @description board and pieces
/*
In the main chess grid, each cell contains an array.
That array contains the info for that cell:

info.team: player the piece belongs to
            -1 = empty cell
            0 = 1st player
            1 = 2nd player
            
info.type: type of piece, enum "type"

---------------------------------

The system goes through 3 modes/states:

0 - Selecting a pawn
1 - Selecting a cell to move that pawn to
    -If can move there, proceed to mode 2
    -If can't move there, go back to mode 0
2 - Moving the pawn / Animating
    -When animation is done:
    -Change turn
    -Back to mode 0

*/

//board grid
board_w = 16; //number of cells in x
board_h = 16; //number of cells in y
board = ds_grid_create(board_w, board_h);

cell_size = 16; //size of each cell in pixels

//position
draw_x = 64; //where to draw the grid in the room
draw_y = 64; 

//properties of each cell
enum info{
    current, // is it the previously selected jumper
    team,   //team it belongs to
    type,  //type of piece, constants below
    p_l //is it pawn-like
}

//types of pieces
enum type{
    empty,
    pawn,
    rook,
    knight,
    bishop,
    king,
    queen,
	blocker,
	peasant,
	squire,
	archer,
	s_pawn,
	croiss,
	jumper,
    leaper,
	lance,
	warlock,
	spy
}

//board sprites for customization
boards[0] = spr_board0;
boards[1] = spr_board1;
boards[2] = spr_board2;
boards[3] = spr_board3;
boards[4] = spr_board4;
boards[5] = spr_board5;

board_spr = 0; //current board sprite selected from the array above

//sprites & colors
//sprite used for each piece type
sprites[type.pawn] = spr_pawn_white;
sprites[type.rook] = spr_rook_white;
sprites[type.knight] = spr_knight_white;
sprites[type.bishop] = spr_bishop_white;
sprites[type.king] = spr_king_white;
sprites[type.queen] = spr_queen_white;
sprites[type.blocker] = spr_blocker_white;
sprites[type.archer] = spr_archer_white;
sprites[type.squire] = spr_squire_white;
sprites[type.lance] = spr_lance_white;
sprites[type.warlock] = spr_warlock_white;
sprites[type.spy] = spr_spy_white;
sprites[type.s_pawn] = spr_s_pawn_white;
sprites[type.jumper] = spr_jumper_white;
sprites[type.leaper] = spr_leaper_white;
sprites[type.peasant] = spr_peasant_white;

//color of the teams' pieces
colors[0] = c_white;
colors[1] = c_black;

// is archer capturing
global.archer_capt = false

// is it a soul turn
global.soul_turn = false

// jumper vars
global.jump = false
global.cpt_x1 = 0
global.cpt_y1 = 0
global.cpt_x2 = 0
global.cpt_y2 = 0
global.pos_x1 = 0
global.pos_y1 = 0
global.pos_x2 = 0
global.pos_y2 = 0

//fill empty
//create an array with properties of an empty cell
//fill grid with that array
var _empty;
_empty[info.team] = -1;
_empty[info.type] = type.empty;
_empty[info.p_l] = false
_empty[info.current] = false

ds_grid_set_region(board, 0, 0, board_w-1, board_h-1, array_new(_empty));

//place pawns
//pawn array
var _pawn;
_pawn[info.type] = type.pawn; //set type to type.pawn
_pawn[info.p_l] = true
_pawn[info.current] = false

//place pawns for player 1
_pawn[info.team] = 0;
ds_grid_set(board, 0, 1, array_new(_pawn));
ds_grid_set(board, 1, 1, array_new(_pawn));
ds_grid_set(board, board_w - 2, 1, array_new(_pawn));
ds_grid_set(board, board_w - 1, 1, array_new(_pawn));
//place pawns for player 2
_pawn[info.team] = 1;
ds_grid_set(board, 0, board_h - 2, array_new(_pawn));
ds_grid_set(board, 1, board_h - 2, array_new(_pawn));
ds_grid_set(board, board_w - 2, board_h - 2, array_new(_pawn));
ds_grid_set(board, board_w - 1, board_h - 2, array_new(_pawn));

//place other pieces
var _array;

//place rooks
_array[info.type] = type.rook;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 0, 0, array_new(_array));
ds_grid_set(board, board_w - 1, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 0, board_h - 1, array_new(_array));
ds_grid_set(board, board_w - 1, board_h - 1, array_new(_array));

//place knights
_array[info.type] = type.knight;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 1, 0, array_new(_array));
ds_grid_set(board, board_w - 2, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 1, board_h - 1, array_new(_array));
ds_grid_set(board, board_w - 2, board_h - 1, array_new(_array));

//place bishops
_array[info.type] = type.bishop;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 4, 0, array_new(_array));
ds_grid_set(board, board_w - 5, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 4, board_h - 1, array_new(_array));
ds_grid_set(board, board_w - 5, board_h - 1, array_new(_array));

//place queen
_array[info.type] = type.queen;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 7, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 7, board_h - 1, array_new(_array));

//place king
_array[info.type] = type.king;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 8, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 8, board_h - 1, array_new(_array));

//place blockers
_array[info.type] = type.blocker;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 6, 0, array_new(_array));
ds_grid_set(board, 9, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 6, board_h - 1, array_new(_array));
ds_grid_set(board, 9, board_h - 1, array_new(_array));

//place archers
_array[info.type] = type.archer;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 2, 0, array_new(_array));
ds_grid_set(board, 13, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 2, board_h - 1, array_new(_array));
ds_grid_set(board, 13, board_h - 1, array_new(_array));

//place squires
_array[info.type] = type.squire;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 3, 0, array_new(_array));
ds_grid_set(board, 12, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 3, board_h - 1, array_new(_array));
ds_grid_set(board, 12, board_h - 1, array_new(_array));

//place lances
_array[info.type] = type.lance;
_array[info.p_l] = true
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 4, 1, array_new(_array));
ds_grid_set(board, 11, 1, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 4, board_h - 2, array_new(_array));
ds_grid_set(board, 11, board_h - 2, array_new(_array));

//place spies
_array[info.type] = type.spy;
_array[info.p_l] = true
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 2, 1, array_new(_array));
ds_grid_set(board, 13, 1, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 2, board_h - 2, array_new(_array));
ds_grid_set(board, 13, board_h - 2, array_new(_array));

//place super pawns
_array[info.type] = type.s_pawn;
_array[info.p_l] = true
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 7, 1, array_new(_array));
ds_grid_set(board, 8, 1, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 7, board_h - 2, array_new(_array));
ds_grid_set(board, 8, board_h - 2, array_new(_array));

//place warlocks
_array[info.type] = type.warlock;
_array[info.p_l] = true
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 3, 1, array_new(_array));
ds_grid_set(board, 12, 1, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 3, board_h - 2, array_new(_array));
ds_grid_set(board, 12, board_h - 2, array_new(_array));

//place jumpers
_array[info.type] = type.jumper;
_array[info.p_l] = true
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 5, 1, array_new(_array));
ds_grid_set(board, 10, 1, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 5, board_h - 2, array_new(_array));
ds_grid_set(board, 10, board_h - 2, array_new(_array));

//place peasants
_array[info.type] = type.peasant;
_array[info.p_l] = false
_array[info.current] = false
_array[info.team] = 0;
ds_grid_set(board, 5, 0, array_new(_array));
ds_grid_set(board, 10, 0, array_new(_array));
_array[info.team] = 1;
ds_grid_set(board, 5, board_h - 1, array_new(_array));
ds_grid_set(board, 10, board_h - 1, array_new(_array));

/* */
///game
randomize();

//font
draw_set_font(ft_chess);

//turns & modes
turn = choose(0, 1); //Which player's turn is it? Choose randomly for a start.
mode = 0; //mode/state:
            //0 - selecting a piece
            //1 - selecting a cell to move that piece to
            //2 - moving that piece

//win
win = -1; //Who won? 0 if player one, 1 if player two. -1 if game not over yet

//selected
sel_p_l = info.p_l
sel_current = info.current
sel_type = type.empty; //which type of piece is selected?
sel_x = 0; //what is the position of the selected cell?
sel_y = 0;

//lost
lost[0] = ds_list_create(); //lost pieces by player 1
lost[1] = ds_list_create(); //lost pieces by player 2
                            //only ded bois in this list. lol

//check
check[0] = false; //is player 1 in check?
check[1] = false; //is played 2 in check?

checking_x = 0; //which cell is being checked?
checking_y = 0;

checked_x = 0; //which cell has been checked?
checked_y = 0;

check_show = false; //whether check is being drawn

//mouse cell position inside board
cell_x = 0;
cell_y = 0;

mouse_out = false; //whether mouse is outside the board/grid

//where to move the piece
move_x = 0;
move_y = 0;


//moveable grid
//this grid sets the cells where the piece can move to true, others to false
//used to check whether a piece can move or not
moveable = ds_grid_create(board_w, board_h);
ds_grid_set_region(moveable, 0, 0, board_w-1, board_h-1, false);

//colors
moveable_color = c_lime;
select_color = c_aqua;
cursor_color_team = c_yellow;
cursor_color_simple = c_white;
check_color = c_red;

//animation
animated = false;

anim_x = 0;
anim_y = 0;

anim_speed = 0.3;

/* */
/*  */
/**/