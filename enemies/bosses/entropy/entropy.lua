entropy_body = custom_sprite("REALMdotEXE/enemies/bosses/entropy/EntropyBody.png", 1, 16, 16, 0)
entropy_eye = custom_sprite("REALMdotEXE/enemies/bosses/entropy/EntropyEye.png", 1, 16, 16, 0)
entropy_spike = custom_sprite("REALMdotEXE/enemies/bosses/entropy/EntropySpike.png", 1, 12, 12, 0)

BG_Closest = custom_sprite("REALMdotEXE/enemies/bosses/entropy/EntropyBGClosest.png", 1, 120, 120, 0)
BG_Towers = custom_sprite("REALMdotEXE/enemies/bosses/entropy/EntropyBGTowers.png", 1, 120, 120, 0)
BG_Furthest = custom_sprite("REALMdotEXE/enemies/bosses/entropy/EntropyBFurthest.png", 1, 120, 120, 0)

decay_sprite = custom_sprite("REALMdotEXE/enemies/bosses/entropy/Decay-Sheet.png", 17, 12, 12, 30)

wrong_turn = custom_music("REALMdotEXE/enemies/bosses/entropy/WrongTurnLoop.ogg", "ignore this")

entropy = enemy_data("hopeless_boss")

entropy.Boss = true


function entropy.ShouldForceBoss()
    return true
end


function entropy.BossIntro(obj)
    init_var(obj, "boss_timer", 0)
    if (get_var(obj, "boss_timer") == 1) then
        play_music(get_asset("mus_silencio"))
        boss_message(120, 80, "entropy")
    end
    if (get_var(obj, "boss_timer") == 90) then
        spawn_enemy(view_x + 120, view_y, "hopeless_boss")
        play_music(wrong_turn)
        play_sound(get_asset("snd_mech"), get_var(obj, "x"))
    end
    set_var(obj, "boss_timer", get_var(obj, "boss_timer") + 1)
end


function entropy.Create(obj)
    set_var(obj, "sprite_index", entropy_body)
    set_var(obj, "hp", 500)
    set_var(obj, "maxhp", 500)
    set_var(obj, "hp_damage", 500)
    set_var(obj, "state", "INTRO")
    set_var(obj, "ai_timer", 0)
    init_var(obj, "siner", 0)
end


EntropyStates = {
    Intro = "INTRO",
    SideDecay = "SIDEDECAY", --Entropy creates decays, and they spew bullets as they move away, firing bullets itself
    WavyThorns = "WAVYTHORNS" --Entropy creates two decays that move left and right, spewing bullets downwards that lean left or right, hardmode gains two more on the side
}


function entropy.Draw(obj)
    
    local dir = get_direction(get_var(obj, "x"), get_var(obj, "y"), player_x, player_y)
    init_var(obj, "spike_spin", 30)
    init_var(obj, "spike_distance", 25)
    init_var(obj, "spike_spin_axis", 30)

    set_var(obj, "image_alpha", 0)
    for i = 0, 350, 60 do
        draw_sprite_ext(get_var(obj, "x") + rot_x(i + get_var(obj, "spike_spin")) * get_var(obj, "spike_distance"), get_var(obj, "y") + rot_y(i + get_var(obj, "spike_spin")) * get_var(obj, "spike_distance"), entropy_spike, 0, i - 90 + get_var(obj, "spike_spin_axis"), 1, 1, create_color(255, 255, 255), 1)

    end
    set_var(obj, "siner", get_var(obj, "siner") + 1)
    draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), entropy_body, 0, 0, 1, 1, create_color(255, 255, 255), 1)

    draw_sprite_ext(get_var(obj, "x") + clamp(dir.x * 5, -5, 5), get_var(obj, "y") + clamp(dir.y * 3, -3, 3), entropy_eye, 0, get_var(obj, "image_angle"), 1, 1, create_color(255, 255, 255), 1)

    if (get_var(obj, "state") == EntropyStates.SideDecay) then
        if (get_var(obj, "ai_timer") < 10) then
            set_var(obj, "spike_spin", lerp(get_var(obj, "spike_spin"), 30, 0.35))
            set_var(obj, "spike_spin_axis", lerp(get_var(obj, "spike_spin_axis"), 30, 0.35))
        end
        set_var(obj, "spike_spin", get_var(obj, "spike_spin") + 2)
        set_var(obj, "spike_spin_axis", get_var(obj, "spike_spin_axis") + 4)
        set_var(obj, "spike_distance", lerp(get_var(obj, "spike_distance"), 35, 0.2) + math.sin(get_var(obj, "siner") / 15))
        if (get_var(obj, "spike_spin") == 360) then
            set_var(obj, "spike_spin", 0)
        end
        if (get_var(obj, "spike_spin_axis") == 360) then
            set_var(obj, "spike_spin_axis", 0)
        end
    else
        if (get_var(obj, "ai_timer") < 10) then
            set_var(obj, "spike_distance", lerp(get_var(obj, "spike_distance"), 25, 0.15))
            set_var(obj, "spike_spin", lerp(get_var(obj, "spike_spin"), 30, 0.35))
            set_var(obj, "spike_spin_axis", lerp(get_var(obj, "spike_spin_axis"), 30, 0.35))
        end

        set_var(obj, "spike_spin", get_var(obj, "spike_spin") + 2)
        set_var(obj, "spike_spin_axis", get_var(obj, "spike_spin_axis") + 2)

        if (get_var(obj, "spike_spin") == 360) then
            set_var(obj, "spike_spin", 0)
        end
        if (get_var(obj, "spike_spin_axis") == 360) then
            set_var(obj, "spike_spin_axis", 0)
        end


    end
end


function entropy.BossBackground(obj)
    init_var(obj, "bg_timer", 0)
    set_var(obj, "bg_timer", lerp(get_var(obj, "bg_timer"), 1, 0.025))
    draw_sprite_ext(view_x + 120, view_y + 90 + (60 * get_var(obj, "bg_timer")), BG_Furthest, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    draw_sprite_ext(view_x + 120, view_y + 210 - (30 * get_var(obj, "bg_timer")), BG_Towers, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    draw_sprite_ext(view_x + 120, view_y + 240 - (60 * get_var(obj, "bg_timer")), BG_Closest, 0, 0, 1, 1, create_color(255, 255, 255), 1)

end


function entropy.Step(obj)

    local decay_rotator = function(v)
        init_var(v, "flipped", math.random() < 0.5)

        if (get_var(v, "flipped")) then
            set_var(v, "image_angle", get_var(v, "image_angle") + 6)
        else
            set_var(v, "image_angle", get_var(v, "image_angle") - 6)
        end
    end

    if (get_var(obj, "behavior") == "dead") then
        init_var(obj, "dead_timer", 0)
        if (get_var(obj, "dead_timer") == 1) then
            clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
        end
        if (get_var(obj, "dead_timer") == 2) then
            call_function("instance_destroy", {obj})
        end

        set_var(obj, "dead_timer", get_var(obj, "dead_timer") + 1)
    end

    if (get_var(obj, "state") == EntropyStates.Intro) then
        set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 120, 0.25) - get_var(obj, "y"))
        print(get_var(obj, "ai_timer"))
    end
    if (get_var(obj, "ai_timer") >= 30 and get_var(obj, "state") == EntropyStates.Intro) then
        set_var(obj, "ai_timer", 0)
        set_var(obj, "state", EntropyStates.SideDecay)
    end

    if (get_var(obj, "state") == EntropyStates.SideDecay) then

        local stretcher = function(v)
            if (get_var(v, "image_xscale") ~= 1) then
                set_var(v, "image_xscale", clamp(get_var(v, "image_xscale"), 0, 1) + 0.05)
            end
        end

        local orbitlets = function(v)
            init_var(v, "spin", 0)
            init_var(v, "radius", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))

            local spin_rate = 0.5
            if hard_mode then
                spin_rate = 1
            end

            set_var(v, "x", get_var(v, "initial_x") + get_var(v, "radius") * rot_x(get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") + get_var(v, "radius") * rot_y(get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "spin", get_var(v, "spin") + spin_rate)
            set_var(v, "radius", get_var(v, "radius") + 1.5)
        end


        local invertlets = function(v)
            init_var(v, "spin", 0)
            init_var(v, "radius", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))

            local spin_rate = 0.5
            if hard_mode then
                spin_rate = 1
            end

            set_var(v, "x", get_var(v, "initial_x") + get_var(v, "radius") * rot_x(-get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") + get_var(v, "radius") * rot_y(-get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "spin", get_var(v, "spin") + spin_rate)
            set_var(v, "radius", get_var(v, "radius") + 1.5)
        end


        local shoot_down = function(v)
            init_var(v, "shoot_timer", math.random(10, 20))
            if (math.fmod(get_var(v, "shoot_timer"), 25) == 0 and get_var(v, "shoot_timer") >= 40 and get_var(v, "shoot_timer") <= 90) then
                play_sound_ext(get_asset("snd_laserblast"), 1, 0.5, get_var(v, "x"))
                local decay_beam = spawn_projectile(get_var(v, "x"), get_var(v, "y"), 0, 2, get_asset("spr_bullet_laserblast"))
                set_var(decay_beam, "image_xscale", 0)
                set_var(decay_beam, "ignore_walls", true)

                set_var(decay_beam, "image_angle", call_function("point_direction", {0, 0, get_var(decay_beam, "hspeed"), get_var(decay_beam, "vspeed")}))

                LumHelp.AddCallback(decay_beam, stretcher)
            end
            set_var(v, "shoot_timer", get_var(v, "shoot_timer") + 1)
        end

        if (get_var(obj, "ai_timer") >= 10) then
            set_var(obj, "hspeed", math.sin(get_var(obj, "siner") / 20))
            set_var(obj, "vspeed", math.cos(get_var(obj, "siner") / 20))
        else
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 110, 0.15) - get_var(obj, "x"))
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 100, 0.15) - get_var(obj, "y"))
        end

        if (math.fmod(get_var(obj, "ai_timer"), 20) == 0) then

            local decay_spawner = spawn_projectile(get_var(obj, "x") + 15, get_var(obj, "y"), 2, -0.5, decay_sprite)
            local decay_spawner_2 = spawn_projectile(get_var(obj, "x") - 15, get_var(obj, "y"), -2, -0.5, decay_sprite)

            set_var(decay_spawner, "ignore_walls", true)
            set_var(decay_spawner_2, "ignore_walls", true)

            LumHelp.AddCallback(decay_spawner, decay_rotator)
            LumHelp.AddCallback(decay_spawner_2, decay_rotator)

            LumHelp.AddCallback(decay_spawner_2, shoot_down)
            LumHelp.AddCallback(decay_spawner, shoot_down)
        end


        if (math.fmod(get_var(obj, "ai_timer"), 50) == 0 and get_var(obj, "ai_timer") >= 40) then
            set_var(obj, "spin_rando", math.random(0, 350))

            play_sound(get_asset("snd_heartbeat"), get_var(obj, "x"))

            local bullet_spread = 360 / 7
            
            if get_global("game_loop") >= 3 and get_global("game_loop") < 7 then
                bullet_spread = 360 / 8
            end
            if get_global("game_loop") >= 7 then
                bullet_spread = 360 / 9
            end

            init_var(obj, "invert", true)

            set_var(obj, "bullet_spin_offset", 0)
            if (get_var(obj, "invert")) then
                for i = 0, 350, bullet_spread do
                    local orbit = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + get_var(obj, "spin_rando")), rot_y(i + get_var(obj, "spin_rando")), get_asset("spr_bullet_medium_nega"))
                    
                    LumHelp.AddCallback(orbit, orbitlets)

                    set_var(orbit, "ignore_walls", true)


                    init_var(orbit, "spin_offset", 0)

                    set_var(obj, "bullet_spin_offset", get_var(obj, "bullet_spin_offset") + bullet_spread)
                    set_var(orbit, "spin_offset", get_var(obj, "bullet_spin_offset"))

                end
            elseif (get_var(obj, "invert") == false) then
                for i = 0, 350, bullet_spread do
                    local orbit = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + get_var(obj, "spin_rando")), rot_y(i + get_var(obj, "spin_rando")), get_asset("spr_bullet_medium_nega"))
                    
                    LumHelp.AddCallback(orbit, invertlets)

                    set_var(orbit, "ignore_walls", true)
                    

                    init_var(orbit, "spin_offset", 0)

                    set_var(obj, "bullet_spin_offset", get_var(obj, "bullet_spin_offset") + bullet_spread)
                    set_var(orbit, "spin_offset", get_var(obj, "bullet_spin_offset"))

                end
            end
            set_var(obj, "invert", not get_var(obj, "invert"))
        end
        if (get_var(obj, "ai_timer") >= 300 and get_var(obj, "ai_timer") < 315) then
            set_var(obj, "hspeed", get_var(obj, "hspeed") * 0.7)
            set_var(obj, "vspeed", get_var(obj, "vspeed") * 0.7)
        elseif (get_var(obj, "ai_timer") == 315) then
            set_var(obj, "ai_timer", 0)
            set_var(obj, "state", EntropyStates.WavyThorns)
        end

    end

    if (get_var(obj, "state") == EntropyStates.WavyThorns) then
        if (get_var(obj, "ai_timer") == 0) then
            set_var(obj, "siner", 30)
        end

        if (get_var(obj, "ai_timer") < 25) then
            
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 100, 0.15) - get_var(obj, "y"))
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 150, 0.15) - get_var(obj, "x"))
        end

        local thorn_swoop = function(v)
            init_var(v, "siner", 0)


            set_var(v, "hspeed", math.sin(get_var(v, "siner") / 25))

            init_var(v, "flipped", math.random() < 0.5)
            if (get_var(v, "flipped")) then
                set_var(v, "siner", get_var(v, "siner") + 2)
            else
                set_var(v, "siner", get_var(v, "siner") - 2)
            end

            set_var(v, "image_angle", call_function("point_direction", {0, 0, get_var(v, "hspeed"), get_var(v, "vspeed")}) - 90)
        end
        
        local thorn_spawn = function(v)
            init_var(v, "shoot_timer", math.random(0, 15))
            local spit_interval = 20

            if hard_mode then
                spit_interval = 15
            end
            
            if (math.fmod(get_var(v, "shoot_timer"), spit_interval) == 0) then
                local decay_beam = spawn_projectile(get_var(v, "x"), get_var(v, "y"), 0, 1.5, entropy_spike)
                set_var(decay_beam, "ignore_walls", true)

                
                set_var(decay_beam, "image_xscale", 0.5)
                set_var(decay_beam, "image_yscale", 0.5)

                LumHelp.AddCallback(decay_beam, thorn_swoop)
            end

            set_var(v, "shoot_timer", get_var(v, "shoot_timer") + 1)
        end

        local thorn_spawn_swoop = function(v)
            init_var(v, "siner", 0)


            set_var(v, "vspeed", math.sin(get_var(v, "siner") / 25))

            init_var(v, "flipped", math.random() < 0.5)
            if (get_var(v, "flipped")) then
                set_var(v, "siner", get_var(v, "siner") + 2)
            else
                set_var(v, "siner", get_var(v, "siner") - 2)
            end
        end
        

        if (get_var(obj, "ai_timer") >= 25 and get_var(obj, "ai_timer") < 300) then
            set_var(obj, "vspeed", math.cos(get_var(obj, "siner") / 15) * 2)
            set_var(obj, "hspeed", math.sin(get_var(obj, "siner") / 30) * 3)
        end

        if (math.fmod(get_var(obj, "ai_timer"), 3) == 0 and get_var(obj, "ai_timer") >= 50 and get_var(obj, "ai_timer") < 300) then
            local anticheese_random = math.random(0, 180)

            play_sound_ext(get_asset("snd_shotspread"), 0.75, 0.25, get_var(obj, "x"))
            local anticheese = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(anticheese_random) * 5, rot_y(anticheese_random) * 5, get_asset("spr_bullet_generic_nega"))
            set_var(anticheese, "image_angle", call_function("point_direction", {0, 0, get_var(anticheese, "hspeed"), get_var(anticheese, "vspeed")}))
            
        end

        if (get_var(obj, "ai_timer") >= 25 and math.fmod(get_var(obj, 'ai_timer'), 75) == 0 and get_var(obj, "ai_timer") < 300) then
            play_sound(get_asset("snd_heartbeat"), get_var(obj, "x"))
            local wavythorner = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), 2, 0, decay_sprite)
            local wavythorner2 = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), -2, 0, decay_sprite)

            set_var(wavythorner, "vspeed", math.sin(get_var(obj, "siner") / 5))
            set_var(wavythorner2, "vspeed", math.sin(get_var(obj, "siner") / 5))

            set_var(wavythorner, "ignore_walls", true)
            set_var(wavythorner2, "ignore_walls", true)


            LumHelp.AddCallback(wavythorner, decay_rotator)
            LumHelp.AddCallback(wavythorner2, decay_rotator)

            LumHelp.AddCallback(wavythorner, thorn_spawn_swoop)
            LumHelp.AddCallback(wavythorner2, thorn_spawn_swoop)
            LumHelp.AddCallback(wavythorner, thorn_spawn)
            LumHelp.AddCallback(wavythorner2, thorn_spawn)
        end
        if (get_var(obj, "ai_timer") >= 300 and get_var(obj, "ai_timer") < 305) then
            set_var(obj, "hspeed", get_var(obj, "hspeed") * 0.7)
            set_var(obj, "vspeed", get_var(obj, "vspeed") * 0.7)
        elseif (get_var(obj, "ai_timer") == 305) then
            set_var(obj, "ai_timer", 0)
            set_var(obj, "state", EntropyStates.SideDecay)
        end
    end

    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end


register_data(entropy)