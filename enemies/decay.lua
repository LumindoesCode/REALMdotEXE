decay_enemy_sprite = custom_sprite("REALMdotEXE/enemies/bosses/entropy/Decay-Sheet.png", 17, 12, 12, 300)
decay_beam_sprite = custom_sprite("REALMdotEXE/enemies/decay_beam.png", 4, 6, 6, 150)

decay = enemy_data("decay")


function decay.Create(obj)
    set_var(obj, "sprite_index", decay_enemy_sprite)
    set_var(obj, "hp", 75)
    set_var(obj, "maxhp", 75)
    set_var(obj, "debris_score", 20)
    set_var(obj, "ai_timer", 0)
end


function decay.Step(obj)
    local dir = get_direction(get_var(obj, "x"), get_var(obj, "y"), player_x, player_y)

    local laser_speener = function(v)
        set_var(v, "angle", get_var(v, "angle") + 1)
        set_var(v, "x", get_var(obj, "x"))
        set_var(v, "y", get_var(obj, "y"))
        if (get_var(obj, "laser_alive")) then
            set_var(v, "lifetime", get_var(v, "lifetime") + 1)
        else
            set_var(v, "lifetime", 0)
        end
    end


    if (get_var(obj, "ai_timer") == 15) then
        for i = 0, 350, 180 do
            init_var(obj, "laser_alive", true)
            local laser = spawn_laser(get_var(obj, "x"), get_var(obj, "y"), i, 1, decay_beam_sprite, get_asset("spr_laser_source_med_green"), get_asset("spr_laserend_ice"))
    
            LumHelp.AddCallback(laser, laser_speener)
        end
    end

    set_var(obj, "image_angle", get_var(obj, "image_angle") + 3)

    set_var(obj, "hspeed", lerp(get_var(obj, "hspeed"), dir.x, 1))
    set_var(obj, "vspeed", lerp(get_var(obj, "vspeed"), dir.y, 1))

    set_var(obj, "ai_timer", get_var(obj, 'ai_timer') + 1)
end


function decay.Destroy(obj)
    set_var(obj, "laser_alive", false)
end


register_data(decay)
