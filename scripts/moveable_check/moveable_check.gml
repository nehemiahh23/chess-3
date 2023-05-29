/// @description  moveable_check(grid, sel_x, sel_y, board, type)
function moveable_check(argument0, argument1, argument2, argument3, argument4) {
	//checks whether a piece type can move to certain cell on a board
	//writes true/false to a grid specified in the 1st arg
	//args
	var _grid = argument0;
	var _sel_x = argument1;
	var _sel_y = argument2;
	var _board = argument3;
	var _sel_type = argument4;

	//vars
	var ver_dir = -((turn*2)-1);

	//loop through all
	for(var h=0; h<board_h; h++){
	    for(var w=0; w<board_w; w++){
	        //get board cell
	        var _array, _type, _team;
	        _array = _board[# w, h];
	        _team = _array[info.team];
	        _type = _array[info.type];
	        //check if moveable and set to grid
	        switch(_sel_type){
	            //pawn
	            case type.pawn: 
	                //straight move
	                if (cell_dist(0, ver_dir, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                if (cell_dist(0, ver_dir*2, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
                
	                //double move on start
	                if ((turn==0 && _sel_y==1) || (turn==1 && _sel_y==board_h-2)){
	                    if (cell_dist(0, ver_dir*3, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                    if (cell_dist(0, ver_dir*4, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                }
                
	                //diagonal attack
	                if ((cell_dist(1, ver_dir, w, h, _sel_x, _sel_y) || cell_dist(-1, ver_dir, w, h, _sel_x, _sel_y)) && _team==!turn) _grid[# w, h] = true;
	            break;
            
	            //rook
	            case type.rook:
	                //move anywhere vertically
					if (abs(_sel_x-w)<2 && abs(_sel_y-h)<2 && _team!=turn) _grid[# w, h] = true;
	                if ((_sel_x==w || _sel_y==h) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team!=turn) {
						if ((h==0 || w==0) || (h==board_h-1 || w==board_w-1)) _grid[# w, h] = true
					}
	            break;
            
	            //knight
	            case type.knight:
	                //move 2.5 steps
	                if ((cell_dist_abs(2, 1, w, h, _sel_x, _sel_y) || cell_dist_abs(1, 2, w, h, _sel_x, _sel_y)) && _team!=turn) _grid[# w, h] = true;
	                if ((cell_dist_abs(2, 0, w, h, _sel_x, _sel_y) || cell_dist_abs(0, 2, w, h, _sel_x, _sel_y)) && _team!=turn) _grid[# w, h] = true;
	                if ((cell_dist_abs(3, 0, w, h, _sel_x, _sel_y) || cell_dist_abs(0, 3, w, h, _sel_x, _sel_y)) && _team!=turn) _grid[# w, h] = true;
	                if ((cell_dist_abs(1, 0, w, h, _sel_x, _sel_y) || cell_dist_abs(0, 1, w, h, _sel_x, _sel_y)) && _team!=turn) _grid[# w, h] = true;
	                if ((cell_dist_abs(1, 1, w, h, _sel_x, _sel_y) || cell_dist_abs(1, 1, w, h, _sel_x, _sel_y)) && _team!=turn) _grid[# w, h] = true;
	                if ((cell_dist_abs(0, 0, w, h, _sel_x, _sel_y) || cell_dist_abs(0, 0, w, h, _sel_x, _sel_y)) && _team!=turn) _grid[# w, h] = true;
	            break;
            
	            //bishop
	            case type.bishop:
	                //diagonal movement
	                if (abs(_sel_x-w)==abs(_sel_y-h) && check_path_empty(w, h, _sel_x, _sel_y, _board) && (_type=type.pawn || _type=type.empty)) _grid[# w, h] = true;
	            break;
            
	            //king
	            case type.king:
	                if (abs(_sel_x-w)<2 && abs(_sel_y-h)<2 && _team!=turn) _grid[# w, h] = true;
	            break;
            
	            //queen
	            case type.queen:
	                //diagonal movement
	                if (abs(_sel_x-w)==abs(_sel_y-h) && check_path_empty(w, h, _sel_x, _sel_y, _board)) _grid[# w, h] = true;
	                //move anywhere vertically
	                if ((_sel_x==w || _sel_y==h) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team!=turn) _grid[# w, h] = true;
	            break;

				//blocker
	            case type.blocker:
	                if (abs(_sel_x-w)<2 && abs(_sel_y-h)<2 && _team==-1) _grid[# w, h] = true;
	            break;

				//squire
	            case type.squire:
	                //move anywhere vertically
	                if ((_sel_x==w || _sel_y==h) && abs(_sel_x-w)<=2 && abs(_sel_y-h)<=2 && _team!=turn) _grid[# w, h] = true;
	            break;

				//archer
	            case type.archer:
	                //diagonal movement
	                if (abs(_sel_x-w)==abs(_sel_y-h) && abs(_sel_x-w)<=4 && abs(_sel_y-h)<=4 && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                //move anywhere vertically
	                if ((_sel_x==w || _sel_y==h) && abs(_sel_x-w)<=4 && abs(_sel_y-h)<=4 && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
					if (cell_dist(0, ver_dir, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team!=-1){
						_grid[# w, h] = true;
						global.archer_capt = true;
					}
					if (cell_dist(0, ver_dir*2, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team!=-1){
						_grid[# w, h] = true;
						global.archer_capt = true;
					}
					if (cell_dist(0, ver_dir*3, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team!=-1){
						_grid[# w, h] = true;
						global.archer_capt = true;
					}
					if (cell_dist(0, ver_dir*4, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team!=-1){
						_grid[# w, h] = true;
						global.archer_capt = true;
					}
	            break;

				//lance
				case type.lance:
					if (_sel_x==w && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team!=turn) {
						if (turn==0 && h>_sel_y) _grid[# w, h] = true;
						if (turn==1 && h<_sel_y) _grid[# w, h] = true;
					}
				
				//warlock
	            case type.warlock: 
	                //straight move
	                if (cell_dist(0, ver_dir, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                if (cell_dist(0, ver_dir*2, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
					if (cell_dist(0, ver_dir*3, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
					if (cell_dist(0, ver_dir*4, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
                
	                //diagonal attack
	                if ((cell_dist(1, ver_dir, w, h, _sel_x, _sel_y) || cell_dist(-1, ver_dir, w, h, _sel_x, _sel_y)) && _team==!turn) _grid[# w, h] = true;
	            break;

				//spy
	            case type.spy: 
	                //straight move
	                if (cell_dist(0, ver_dir, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                if (cell_dist(0, ver_dir*2, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
                
	                //double move on start
	                if ((turn==0 && _sel_y==1) || (turn==1 && _sel_y==board_h-2)){
	                    if (cell_dist(0, ver_dir*3, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                    if (cell_dist(0, ver_dir*4, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                }
                
	                //diagonal attack
	                if ((cell_dist(1, ver_dir, w, h, _sel_x, _sel_y) || cell_dist(-1, ver_dir, w, h, _sel_x, _sel_y)) && _team==!turn) _grid[# w, h] = true;
	            break;

				//super pawn
	            case type.s_pawn: 
	                //straight move
	                if (cell_dist(0, ver_dir, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                if (cell_dist(0, ver_dir*2, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
                
	                //double move on start
	                if ((turn==0 && _sel_y==1) || (turn==1 && _sel_y==board_h-2)){
	                    if (cell_dist(0, ver_dir*3, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                    if (cell_dist(0, ver_dir*4, w, h, _sel_x, _sel_y) && check_path_empty(w, h, _sel_x, _sel_y, _board) && _team==-1) _grid[# w, h] = true;
	                }
                
	                //diagonal attack
	                if ((cell_dist(1, ver_dir, w, h, _sel_x, _sel_y) || cell_dist(-1, ver_dir, w, h, _sel_x, _sel_y)) && _team==!turn) _grid[# w, h] = true;
	            break;

				//jumper
	            case type.jumper:
	                //diagonal move
	                if ((cell_dist(1, ver_dir, w, h, _sel_x, _sel_y) || cell_dist(-1, ver_dir, w, h, _sel_x, _sel_y)) && _team==-1) _grid[# w, h] = true;
	                
					//capture
					if (cell_dist(1, ver_dir, w, h, _sel_x, _sel_y) && _team==!turn) {
						_grid[# w+1, h+ver_dir] = true;
						global.cpt_x1 = w
						global.cpt_y1 = h
						global.pos_x1 = w+1
						global.pos_y1 = h+ver_dir
					}
	                if (cell_dist(-1, ver_dir, w, h, _sel_x, _sel_y) && _team==!turn) {
						_grid[# w-1, h+ver_dir] = true;
						global.cpt_x2 = w
						global.cpt_y2 = h
						global.pos_x2 = w-1
						global.pos_y2 = h+ver_dir
					}
	            break;

				//leaper
	            case type.leaper:
	                //diagonal move
	                if (abs(_sel_x-w)==abs(_sel_y-h) && abs(_sel_x-w)==1 && abs(_sel_y-h)==1 && _team==-1) _grid[# w, h] = true;
	                
					//capture
					if (cell_dist(1, ver_dir, w, h, _sel_x, _sel_y) && _team==!turn) _grid[# w+1, h+ver_dir] = true;
	                if (cell_dist(-1, ver_dir, w, h, _sel_x, _sel_y) && _team==!turn) _grid[# w-1, h+ver_dir] = true;
	                if (cell_dist(1, -ver_dir, w, h, _sel_x, _sel_y) && _team==!turn) _grid[# w-1, h+ver_dir] = true;
	                if (cell_dist(-1, -ver_dir, w, h, _sel_x, _sel_y) && _team==!turn) _grid[# w-1, h+ver_dir] = true;
	            break;
	        }
	        //if king piece is there, don't move
	        if (_grid[# w, h] && _type==type.king && _team==!turn){
	            _grid[# w, h] = false;
	            check[!turn] = true;
            
	            //set check coords
	            checking_x = draw_x + _sel_x*cell_size;
	            checking_y = draw_y + _sel_y*cell_size;
            
	            checked_x = draw_x + w*cell_size;
	            checked_y = draw_y + h*cell_size;
	        }
			//cant capture blockers
			if (_grid[# w, h] && _team==!turn && _type==type.blocker){
				_grid[# w, h] = false
			}
	    }
	}
	


}
