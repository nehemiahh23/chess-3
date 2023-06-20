button_animate();

//activate settings
if (button_click()){
    active = !active;
    
    if (ds_list_size(set_inst)!=0 && active) active = false;
    
    if (active){
        for(var i=0; i<array_length_1d(set_obj); i++){
            set_inst[| i] = instance_create(x, y, set_obj[i]);
            
            dest_x[i] = x + (dist*(i+1));
        }
    }
}

//if active, push out buttons
if (active){
    for(var i=0; i<ds_list_size(set_inst); i++){
        set_inst[| i].x = lerp(set_inst[| i].x, dest_x[i], 0.2);
    }
}

//if inactive, push in buttons
else if (!active){
    for(var i=0; i<ds_list_size(set_inst); i++){
        set_inst[| i].x = lerp(set_inst[| i].x, x, 0.2);
        
        //destroy button if close
        if (abs(x - set_inst[| i].x)<2){
            instance_destroy(set_inst[| i]);
            ds_list_delete(set_inst, i);
        }
    }
}

