star_sprite = custom_sprite("REALMdotEXE/enemies/bosses/star_creature/star_creature.png", 1, 24, 27, 0)


star = enemy_data("star_boss")


star.Boss =true
function star.ShouldForceBoss()
    return FORCE_STAR and (get_global("current_floormap") == get_global("floormap_2"))
end


--star.BossFloor = 2


function star.BossIntro(obj)
    init_var(obj, "boss_timer", 0)
    if (get_var(obj, "boss_timer") == 0) then
        spawn_enemy(view_x + 120, view_y + 120, "star_boss")
    end
    if (get_var(obj, "boss_timer") == 60) then
        boss_message(120, 80, "star")
    end
    if (get_var(obj, "boss_timer") == 0) then
        play_music(get_asset("mus_the_4th"))
    end
    set_var(obj, "boss_timer", get_var(obj, "boss_timer") + 1)
end


function star.Create(obj)
    set_var(obj, "sprite_index", star_sprite)
    set_var(obj, "hp", 500)
    set_var(obj, "maxhp", 500)
    set_var(obj, "hp_damage", 500)
    set_var(obj, "state", "INTRO")
    set_var(obj, "ai_timer", 0)
end


StarStates = {
    Intro = "INTRO",
    StarSucc = "STARSUCC", --Attacks similarly to Database's rings attack, but moves up and down while doing it
    Dead = "DED"
}


function star.Draw(obj)

    if (math.fmod(get_var(obj, "ai_timer"), 10) == 0) then
        local sp = spawn_particle(get_var(obj, "x"), get_var(obj, "y"), 0, 0, star_sprite)

        set_var(sp, "image_alpha", 0.75)
        set_var(sp, "image_xscale", 0.75)
        set_var(sp, "image_yscale", 0.75)


        local fader = function(v)
            set_var(v, "image_alpha", get_var(v, "image_alpha") - 0.01)
            set_var(v, "image_xscale", get_var(v, "image_xscale") - 0.01)
            set_var(v, "image_yscale", get_var(v, "image_yscale") - 0.01)
        end

        if (get_var(sp, "image_alpha") == 0.5) then
            call_function("instance_destroy", {sp})
        end

        LumHelp.AddCallback(sp, fader)
    end
end


function star.Step(obj)
    init_var(obj, "siner", 0)
    set_var(obj, "siner", get_var(obj, "siner") + 1)

    if (get_var(obj, "behavior") == "dead") then
        set_var(obj, "state", StarStates.Dead)
        init_var(obj, "dead_timer", 0)

        if (get_var(obj, "dead_timer") == 0) then
            clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
        end

        if (get_var(obj, "dead_timer") == 30) then
            play_sound(get_asset("snd_boom"), view_x + 120)
            add_screenshake(5)

        elseif (get_var(obj, "dead_timer") == 31) then
            call_function("instance_destroy", {obj})
        end
        set_var(obj, "dead_timer", get_var(obj, "dead_timer") + 1)
    end


    if (get_var(obj, "state") == StarStates.Intro and get_var(obj, "ai_timer") >= 30) then
        set_var(obj, "ai_timer", 0)
        set_var(obj, "state", StarStates.StarSucc)
    end

    if (get_var(obj, "state") == StarStates.StarSucc) then
        if (get_var(obj, "ai_timer") < 60) then
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 170, 0.1) - get_var(obj, "y"))
        end

        if (get_var(obj, "ai_timer") >= 60) then

            set_var(obj, "vspeed", math.sin(get_var(obj, "siner") / 25) * 1)

            set_var(obj, "spin_rando", math.random(0, 350))
    
            local stop_and_schmoove = function(v)
                init_var(v, "stop_timer", 0)
                init_var(v, "initial_x", get_var(v, "x"))
                init_var(v, "initial_y", get_var(v, "y"))

                if (get_var(v, "stop_timer") == 15) then
                    set_var(v, "hspeed", 0)
                    set_var(v, "vspeed", 0)
                elseif (get_var(v, "stop_timer") == 25) then
                    play_sound(get_asset("snd_pball_absorb"), get_var(v, "x"))
                    local recent_dir = get_direction(get_var(v, "initial_x"), get_var(v, "initial_y"), player_x, player_y)
                    set_var(v, "hspeed", recent_dir.x * 2)
                    set_var(v, "vspeed", recent_dir.y * 2)
                end
                set_var(v, "stop_timer", get_var(v, "stop_timer") + 1)
            end
    
            if (math.fmod(get_var(obj, "ai_timer"), 50) == 0) then
                init_var(obj, "invert", false)
                if (get_var(obj, "invert")) then
                    set_var(obj, "image_angle", 15)
                else
                    set_var(obj, "image_angle", -15)
                end
                set_var(obj, "invert", not get_var(obj, "invert"))
                print(get_var(obj, "invert"))

                local star_amount = 90
                local loop_offset = 45

                if (get_global("game_loop") >= 5) then
                    star_amount = 72
                    loop_offset = 0
                end


                play_sound(get_asset("snd_revolver"), get_var(obj, "x"))
                for i = 1, 350, star_amount do
                    local star_stop = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + get_var(obj, "spin_rando")) * 1.5, rot_y(i + get_var(obj, "spin_rando")) * 1.5, get_asset("spr_enemy_bullet_dstar"))
                    LumHelp.AddCallback(star_stop, stop_and_schmoove)
                    spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), -rot_x(i + get_var(obj, "spin_rando") + loop_offset) * 1.5, -rot_y(i + get_var(obj, "spin_rando") + loop_offset) * 1.5, get_asset("spr_enemy_bullet_dstar_blue"))
                end
                if hard_mode then
                    for i = 1, 350, 45 do
                        spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + get_var(obj, "spin_rando")), rot_y(i + get_var(obj, "spin_rando")), get_asset("spr_blinkbullet"))
                    end
                end
            end
            

            set_var(obj, "image_angle", lerp(get_var(obj, "image_angle"), 0, 0.2 * 0.2))
            
        end
    end

    if (get_var(obj, "state") == StarStates.Dead) then
        set_var(obj, "vspeed", 0)
        set_var(obj, "ai_timer", 0)
    end
    

    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end


register_data(star)