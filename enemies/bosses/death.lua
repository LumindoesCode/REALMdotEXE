death_inc_left_sprite = custom_sprite("REALMdotEXE/enemies/bosses/DI_Left.png", 1, 16, 16, 0)
death_inc_right_sprite = custom_sprite("REALMdotEXE/enemies/bosses/DI_Right.png", 1, 16, 16, 0)
death_inc_hitbox = custom_sprite("REALMdotEXE/enemies/bosses/DI.png", 1, 16, 16, 0)

sploding_eyelet_sprite = custom_sprite("REALMdotEXE/enemies/bosses/DI_Eyelet-Sheet.png", 5, 8, 8, 20)


death_inc = enemy_data("death_incarnate")

death_inc.Boss = true
function death_inc.ShouldForceBoss()
    return FORCE_DEATH and (get_global("current_floormap") == get_global("floormap_1"))
end


death_inc.BossFloor = 1


function death_inc.BossIntro(obj)
    init_var(obj, "boss_timer", 0)
    if (get_var(obj, "boss_timer") == 60) then
        spawn_enemy(view_x + 120, view_y + 120, "death_incarnate")
    end
    if (get_var(obj, "boss_timer") == 60) then
        boss_message(120, 120, "death scout")
    end
    if (get_var(obj, "boss_timer") == 120) then
        play_music(get_asset("mus_boss_spooky"))
    end
    set_var(obj, "boss_timer", get_var(obj, "boss_timer") + 1)
end


function death_inc.Create(obj)
    set_var(obj, "sprite_index", death_inc_hitbox)
    set_var(obj, "hp", 1500)
    set_var(obj, "maxhp", 1500)
    set_var(obj, "hp_damage", 1500)
    set_var(obj, "state", "INTRO")
    set_var(obj, "ai_timer", 0)
    set_var(obj, "hspeed_target", 0)
    set_var(obj, "vspeed_target", 0)
end


function death_inc.Draw(obj)
    init_var(obj, "right_sprite_position_x", 0)
    init_var(obj, "left_sprite_position_x", 0)

    set_var(obj, "image_alpha", 0)

    draw_sprite_ext(get_var(obj, "x") + get_var(obj, "left_sprite_position_x"), get_var(obj, "y"), death_inc_left_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    draw_sprite_ext(get_var(obj, "x") + get_var(obj, "right_sprite_position_x"), get_var(obj, "y"), death_inc_right_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)


    if (get_var(obj, "state") == States.Eyes) then

        set_var(obj, "right_sprite_position_x", (lerp(get_var(obj, "right_sprite_position_x"), 15, 0.1)))
        set_var(obj, "left_sprite_position_x", (lerp(get_var(obj, "left_sprite_position_x"), -15, 0.1)))

    elseif (get_var(obj, "state") == States.SpitterMouth) then

        if (get_var(obj, "ai_timer") >= 30 and get_var(obj, "ai_timer") <= 60) then
            if (math.fmod(get_var(obj, "ai_timer"), 15) == 0) then
                set_var(obj, "right_sprite_position_x", (lerp(get_var(obj, "right_sprite_position_x"), 15, 0.1)))
                set_var(obj, "left_sprite_position_x", (lerp(get_var(obj, "left_sprite_position_x"), -15, 0.1)))
            else
                set_var(obj, "right_sprite_position_x", (lerp(get_var(obj, "right_sprite_position_x"), 0, 0.1)))
                set_var(obj, "left_sprite_position_x", (lerp(get_var(obj, "left_sprite_position_x"), 0, 0.1)))
            end
        end
    elseif (get_var(obj, "state") == States.Roar) then
        if (get_var(obj, "ai_timer") >= 0 and get_var(obj, "ai_timer") <= 90) then
            set_var(obj, "right_sprite_position_x", (lerp(get_var(obj, "right_sprite_position_x"), 15, 0.1)))
            set_var(obj, "left_sprite_position_x", (lerp(get_var(obj, "left_sprite_position_x"), -15, 0.1)))
        else
            set_var(obj, "right_sprite_position_x", (lerp(get_var(obj, "right_sprite_position_x"), 0, 0.1)))
            set_var(obj, "left_sprite_position_x", (lerp(get_var(obj, "left_sprite_position_x"), 0, 0.1)))
        end
    else
        set_var(obj, "right_sprite_position_x", (lerp(get_var(obj, "right_sprite_position_x"), 0, 0.1)))
        set_var(obj, "left_sprite_position_x", (lerp(get_var(obj, "left_sprite_position_x"), 0, 0.1)))
    end
end


function ChangeState(obj, states)
    set_var(obj, "ai_timer", 0)
    local state = states[math.random(1, #states)]
    set_var(obj, "state", state)
end


function death_inc.BossBackground(obj)
    
end


States = {
    Intro = "INTRO",
    Roar = "ROAR",
    Whirlwind = "WHIRLWIND", -- a whirlwind of bullets comes out of DI's mouth, slowly moving towards the player
    Eyes = "EYES", -- Spawns eyeballs that explode into bullets
    SpitterMouth = "SPITTERMOUTH" -- spits out three bullet spreads
}


function death_inc.Step(obj)
    local dir = get_direction(get_var(obj, "x"), get_var(obj, "y"), player_x, player_y)

    if (get_var(obj, "behavior") == "dead") then
        play_sound(get_asset("snd_boom"), view_x + 120)
        clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
        add_screenshake(5)
        call_function("instance_destroy", {obj})
    end

    if (get_var(obj, "state") == States.Intro) then

        if (get_var(obj, "ai_timer") <= 1) then
            set_var(obj, "y", view_y)
            set_var(obj, "vspeed", 10)
        elseif (get_var(obj, "ai_timer") == 60) then
            set_var(obj, "vspeed", 0)
            set_var(obj, "ai_timer", 0)
            set_var(obj, "state", States.Roar)
        else
            set_var(obj, "vspeed", get_var(obj, "vspeed") * 0.9)
        end
    end

    if (get_var(obj, "state") == States.Roar) then
        if (get_var(obj, "ai_timer") == 0) then
            play_sound(get_asset("snd_roar"), get_var(obj, "x"))
        end
        if (get_var(obj, "ai_timer") <= 60) then
            add_screenshake(2)
        end
        if (get_var(obj, "ai_timer") == 90) then
            set_var(obj, "ai_timer", 0)
            set_var(obj, "state", States.Whirlwind)
        end
    end
    
    if (get_var(obj, "state") == States.Whirlwind) then
        local whirl_spread = 120
        local di_speed_modifier = 0.2

        if hard_mode then
            di_speed_modifier = 0.35
        end

        if (get_global("game_loop") >= 3 and get_global("game_loop") < 6) then
            whirl_spread = whirl_spread - 30
        elseif (get_global("game_loop") >= 7) then
            whirl_spread = whirl_spread - 48
        end

        init_var(obj, "bullet_rotation", 0)

        if (get_var(obj, "ai_timer") == 20) then
            play_sound(get_asset("snd_gather_alt"), get_var(obj, "x"))
        end

        if (get_var(obj, "ai_timer") >= 60 and get_var(obj, "ai_timer") <= 180) then

            set_var(obj, "vspeed", (lerp(get_var(obj, "vspeed"), dir.y, 1) * di_speed_modifier))
            set_var(obj, "hspeed", (lerp(get_var(obj, "hspeed"), dir.x, 1) * di_speed_modifier))
    
            if (math.fmod(get_var(obj, "ai_timer"), 10) == 0) then
                play_sound(get_asset("snd_rapid_fire"), get_var(obj, "x"))
                for i = 1, 350, whirl_spread do
                    local whirlb = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), (rot_x(i + get_var(obj, "bullet_rotation")) * 2), (rot_y(i + get_var(obj, "bullet_rotation")) * 2), get_asset("spr_enemy_bullet_hook"))
                    set_var(whirlb, "image_angle", call_function("point_direction", {0, 0, get_var(whirlb, "hspeed"), get_var(whirlb, "vspeed")}))
                end
                set_var(obj, "bullet_rotation", get_var(obj, "bullet_rotation") + 25)
            end
        elseif (get_var(obj, "ai_timer") >= 180) then
            set_var(obj, "ai_timer", 0)
            ChangeState(obj, {States.Eyes, States.SpitterMouth})
        end
    end

    if (get_var(obj, "state") == States.Eyes) then
        set_var(obj, "vspeed", 0)
        set_var(obj, "hspeed", 0)

        local eye_spew_speed = 30
        local eye_spew_amount = 120

        if hard_mode then
            eye_spew_amount = 72
        end


        local slower = function(v)
            set_var(v, "hspeed", get_var(v, "hspeed") * 0.98)
            set_var(v, "vspeed", get_var(v, "vspeed") * 0.98)
        end
        local explode = function(v)
            init_var(v, "boom_timer", 0)

            if (get_var(v, "boom_timer") == 30) then
                add_screenshake(2)
                play_sound(get_asset("snd_shotspread"), get_var(v, "x"))
                init_var(v, "spin_rando", math.random(0, 350))

                for i = 1, 350, eye_spew_amount do
                    local eyebb = spawn_projectile(get_var(v, "x"), get_var(v, "y"), rot_x(i + get_var(v, "spin_rando")), rot_y(i + get_var(v, "spin_rando")), get_asset("spr_bullet_dopple_blue"))
                    set_var(eyebb, "image_angle", call_function("point_direction", {0, 0, get_var(eyebb, "hspeed"), get_var(eyebb, "vspeed")}))
                    local eyepp = spawn_projectile(get_var(v, "x"), get_var(v, "y"), -rot_x(i + get_var(v, "spin_rando")) * 1.5, -rot_y(i + get_var(v, "spin_rando")) * 1.5, get_asset("spr_bullet_dopple_purple"))
                    set_var(eyepp, "image_angle", call_function("point_direction", {0, 0, get_var(eyepp, "hspeed"), get_var(eyepp, "vspeed")}))
                end
                call_function("instance_destroy", {v})
            end
            set_var(v, "boom_timer", get_var(v, "boom_timer") + 1)
        end

        if (get_var(obj, "ai_timer") <= 60) then
            if (math.fmod(get_var(obj, "ai_timer"), eye_spew_speed) == 0) then

                local eyeb = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), dir.x * 2, dir.y * 2, sploding_eyelet_sprite)
    
                LumHelp.AddCallback(eyeb, slower)
                LumHelp.AddCallback(eyeb, explode)
            end
        else
            set_var(obj, "ai_timer", 0)
            set_var(obj, "state", States.Whirlwind)
        end
        
    end

    if (get_var(obj, "state") == States.SpitterMouth) then
        local spit_direction = call_function("point_direction", {get_var(obj, "x"), get_var(obj, "y"), player_x, player_y})
        
        local balls_density = 30
        local balls_spread = 90
        local hard_help = 3

        if hard_mode then
            balls_spread = 120
            hard_help = 2
        end

        if (get_var(obj, "ai_timer") >= 30 and get_var(obj, "ai_timer") <= 60) then
            if (math.fmod(get_var(obj, "ai_timer"), 15) == 0) then
                play_sound(get_asset("snd_thunk"), get_var(obj, "x"))
                for i = 1, balls_spread, balls_density do
                    local wingp = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + spit_direction - (balls_spread / hard_help)) * 2, rot_y(i + spit_direction - (balls_spread / hard_help)) * 2, get_asset("spr_bullet_dopple_red"))
                    set_var(wingp, "image_angle", call_function("point_direction", {0, 0, get_var(wingp, "hspeed"), get_var(wingp, "vspeed")}))
                    if hard_mode then
                        local wingpp = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + spit_direction - 30) * 2.5, rot_y(i + spit_direction - 30) * 2.5, get_asset("spr_bullet_dopple_red"))
                        set_var(wingpp, "image_angle", call_function("point_direction", {0, 0, get_var(wingpp, "hspeed"), get_var(wingpp, "vspeed")}))
                        
                    end
                end
                set_var(obj, "hspeed", (lerp(get_var(obj, "hspeed"), -dir.x, 0.05)))
                set_var(obj, "vspeed", (lerp(get_var(obj, "vspeed"), -dir.y, 0.05)))
            end
        elseif (get_var(obj, "ai_timer") >= 60) then
            set_var(obj, "ai_timer", 0)
            set_var(obj, "state", States.Whirlwind)
        end
    end

    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end


function death_inc.Destroy(obj)
    
end



register_data(death_inc)