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


entropy.BossFloor = 3


function entropy.ShouldForceBoss()
    return FORCE_ENTROPY and (get_global("current_floormap") == get_global("floormap_3"))
end


function entropy.BossIntro(obj)
    init_var(obj, "boss_timer", 0)
    if (get_var(obj, "boss_timer") == 1) then
        play_music(get_asset("mus_silencio"))
    end
    if (get_var(obj, "boss_timer") == 1) then
        spawn_object(view_x + 120, view_y, "hopeless_boss")
    end
    set_var(obj, "boss_timer", get_var(obj, "boss_timer") + 1)
end


function entropy.Create(obj)
    set_var(obj, "sprite_index", entropy_body)
    set_var(obj, "hp", 3500)
    set_var(obj, "maxhp", 3500)
    set_var(obj, "hp_damage", 3500)
    set_var(obj, "state", "INTRO")
    set_var(obj, "ai_timer", 0)
    set_var(obj, "debris_score", 1500)
    init_var(obj, "siner", 0)
end


EntropyStates = {
    Intro = "INTRO",
    SideDecay = "SIDEDECAY", --Entropy creates decays, and they spew bullets as they move away, firing bullets itself
    WavyThorns = "WAVYTHORNS", --Entropy creates two decays that move left and right, spewing bullets downwards that lean left or right
    ThornSlash = "THORNSLASH", --Entropy creates several large slashes of bullets, similar to Charlie's attack (lol)
    RingleaderSpeen = "RINGLEADERSPEEN", --Entropy creates decays in a ring around itself, before it wildly spins them around until they detonate
    DecayTornado = "DECAYTORNADO", --Entropy creates two Decays that spin around itself, both spewing bullets upwards that fall down
    Dead = "DED"
}


function ChangeState(obj, states)
    set_var(obj, "ai_timer", 0)
    local state = states[math.random(1, #states)]
    set_var(obj, "state", state)
end


function entropy.Draw(obj)

    
    local dir = get_direction(get_var(obj, "x"), get_var(obj, "y"), player_x, player_y)
    init_var(obj, "spike_spin", 30)
    init_var(obj, "spike_distance", 25)
    init_var(obj, "spike_spin_axis", 30)

    set_var(obj, "image_alpha", 0)
    for i = 0, 350, 60 do
        draw_sprite_ext(get_var(obj, "x") + rot_x(i + get_var(obj, "spike_spin")) * get_var(obj, "spike_distance"), get_var(obj, "y") + rot_y(i + get_var(obj, "spike_spin")) * get_var(obj, "spike_distance"), entropy_spike, 0, i - 90 + get_var(obj, "spike_spin_axis"), 1, 1, create_color(255, 255, 255), 1)

    end

    init_var(obj, "sizer", 0)
    if (get_var(obj, "state") == EntropyStates.Intro and get_var(obj, "ai_timer") < 240) then

        draw_sprite_ext(view_x + 120, view_y + 120, entropy_body, 0, 0, get_var(obj, "sizer"), get_var(obj, "sizer"), create_color(255, 255, 255), 1)

        set_var(obj, "sizer", get_var(obj, "sizer") + 0.005)
    elseif (get_var(obj, "state") == EntropyStates.Intro) then
        set_var(obj, "spike_spin", get_var(obj, 'spike_spin') + 4)
        set_var(obj, "spike_spin_axis", get_var(obj, 'spike_spin_axis') + 8)
        set_var(obj, "spike_distance", 50)
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


    elseif (get_var(obj, "state") == EntropyStates.ThornSlash) then
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


        if (math.fmod(get_var(obj, "ai_timer"), 35) == 0) then
            set_var(obj, "spike_distance", 35)
        end

        set_var(obj, "spike_distance", lerp(get_var(obj, "spike_distance"), 25, 0.05))

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
        ChangeState(obj, {EntropyStates.Dead})
    end

    if (get_var(obj, "state") == EntropyStates.Intro) then
        local decayticle_deleter = function(v)
            init_var(v, "waiter", 0)

            if (get_var(v, "x") >= view_x + 115 and get_var(v, "x") <= view_x + 125) then
                play_sound(get_asset("snd_gather"), view_x + 120)
                set_var(v, "waiter", get_var(v, "waiter") + 1)
                call_function("instance_destroy", {v})
            end
            
        end

        if (math.fmod(get_var(obj, "ai_timer"), 25) == 0 and get_var(obj, "ai_timer") < 240) then
            local random_y = math.random(0, 240)

            local random_x = math.random(0, 1)

            if random_x == 0 then
                random_x = 0
            end
            if random_x == 1 then
                random_x = 280
            end

            local decayticle = spawn_projectile(view_x - 20 + random_x, view_y + 60 + random_y, 0, 0, decay_sprite)
            
            local decay_dir = get_direction(get_var(decayticle, "x"), get_var(decayticle, "y"), view_x + 120, view_y + 120)

            set_var(decayticle, "damage", 0)
            set_var(decayticle, "ignore_walls", true)

            
            set_var(decayticle, 'hspeed', decay_dir.x * 2)
            set_var(decayticle, 'vspeed', decay_dir.y * 2)
            set_var(decayticle, "image_angle", math.random(0, 359))

            LumHelp.AddCallback(decayticle, decay_rotator)
            LumHelp.AddCallback(decayticle, decayticle_deleter)
        end

        if (get_var(obj, "ai_timer") == 240) then
            play_music(wrong_turn)
            clear_bullets(view_x + 120, view_y + 120)
            play_sound(get_asset("snd_roar"), get_var(obj, "x"))
        end

        if (get_var(obj, "ai_timer") >= 240 and get_var(obj, "ai_timer") < 300) then
            set_var(obj, 'x', view_x + 120)
            set_var(obj, 'y', view_y + 120)
            add_screenshake(10)
        end
        if (get_var(obj, "ai_timer") >= 300) then
            ChangeState(obj, {EntropyStates.DecayTornado, EntropyStates.RingleaderSpeen, EntropyStates.SideDecay, EntropyStates.ThornSlash, EntropyStates.WavyThorns})
        end
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

        if (get_var(obj, "ai_timer") == 1) then
            play_sound(get_asset("snd_dash_super"), get_var(obj, "x"))
        end
        if (get_var(obj, "ai_timer") >= 10) then
            set_var(obj, "hspeed", math.sin(get_var(obj, "siner") / 20))
            set_var(obj, "vspeed", math.cos(get_var(obj, "siner") / 20))
        else
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 120, 0.25) - get_var(obj, "x"))
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 100, 0.25) - get_var(obj, "y"))
        end

        if (math.fmod(get_var(obj, "ai_timer"), 20) == 0) then

            local decay_spawner = spawn_projectile(get_var(obj, "x") + 15, get_var(obj, "y"), 2, -0.5, decay_sprite)
            local decay_spawner_2 = spawn_projectile(get_var(obj, "x") - 15, get_var(obj, "y"), -2, -0.5, decay_sprite)

            set_var(decay_spawner, "ignore_walls", true)
            set_var(decay_spawner_2, "ignore_walls", true)
            set_var(decay_spawner, "image_angle", math.random(0, 359))
            set_var(decay_spawner_2, "image_angle", math.random(0, 359))
            set_var(decay_spawner, "nobreak", true)
            set_var(decay_spawner_2, "nobreak", true)

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
            ChangeState(obj, {EntropyStates.WavyThorns, EntropyStates.ThornSlash, EntropyStates.RingleaderSpeen, EntropyStates.DecayTornado})
        end

    end

    if (get_var(obj, "state") == EntropyStates.WavyThorns) then
        if (get_var(obj, "ai_timer") == 1) then
            play_sound(get_asset("snd_dash_super"), get_var(obj, "x"))
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

            set_var(wavythorner, "image_angle", math.random(0, 359))
            set_var(wavythorner2, "image_angle", math.random(0, 359))

            set_var(wavythorner, "nobreak", true)
            set_var(wavythorner2, "nobreak", true)


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
            ChangeState(obj, {EntropyStates.ThornSlash, EntropyStates.SideDecay, EntropyStates.RingleaderSpeen, EntropyStates.DecayTornado})
        end
    end

    if (get_var(obj, "state") == EntropyStates.ThornSlash) then

        local decay_jumpscare = function(v)
            set_var(v, "vspeed", get_var(v, 'vspeed') - 0.25)
        end

        local down_driller = function(v)
            init_var(v, "drill_timer", 0)

            if (get_var(v, "drill_timer") == 30) then
                local decay_parti = spawn_particle(get_var(v, "x"), get_var(v, "y") + 30, 0, 6, decay_sprite)
                set_var(decay_parti, "image_angle", math.random(0, 359))

                LumHelp.AddCallback(decay_parti, decay_jumpscare)
                LumHelp.AddCallback(decay_parti, decay_rotator)

                add_screenshake(3)
                play_sound(get_asset("snd_buzzap"), get_var(v, "x"))
                set_var(v, "vspeed", 15)
            end

            if (get_var(v, "drill_timer") > 30 and get_var(v, "drill_timer") <= 55) then
                set_var(v, "vspeed", get_var(v, "vspeed") * 0.8)
            elseif (get_var(v, "drill_timer") > 55) then
                set_var(v, "vspeed", lerp(get_var(v, "vspeed"), 2, 0.1))
            end

            set_var(v, "drill_timer", get_var(v, "drill_timer") + 1)
        end


        if (get_var(obj, "ai_timer") == 1) then
            set_var(obj, "siner", 1)
            play_sound(get_asset("snd_gather"), get_var(obj, "x"))
        elseif (get_var(obj, "ai_timer") < 30) then
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 60, 0.05) - get_var(obj, "x"))
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 120, 0.05) - get_var(obj, "y"))
        end

        if (get_var(obj, "ai_timer") >= 30 and get_var(obj, "ai_timer") < 450) then
            set_var(obj, "hspeed", -math.cos(get_var(obj, "siner") / 150) * 1.5)
            set_var(obj, "vspeed", math.sin(get_var(obj, "siner") / 150))

            init_var(obj, "delayer", math.random(0, 359))
            init_var(obj, "spawn_things", 0)

            local drill_interval = 60

            if (get_global("game_loop") >= 3 and get_global("game_loop") < 7) then
                drill_interval = 50
            elseif (get_global("game_loop") >= 7) then
                drill_interval = 40
            end

            if (math.fmod(get_var(obj, "ai_timer"), 35) == 0) then
                set_var(obj, "spawn_things", 5)
                set_var(obj, "delayer", get_var(obj, "delayer") + 30)
            end

            if (math.fmod(get_var(obj, "ai_timer"), drill_interval) == 0) then
                local random_spot = math.random(40, 200)

                local driller = spawn_projectile(view_x + random_spot, view_y, 0, 0, entropy_spike)

                spawn_particle(get_var(driller, "x"), get_var(driller, "y") + 80, 0, 0, get_asset("spr_danger_new"))

                set_var(driller, "nobreak", true)
                set_var(driller, "swattable", false)
                set_var(driller, "ignore_walls", true)
                set_var(driller, "image_angle", 180)
                LumHelp.AddCallback(driller, down_driller)
            end
            
            if (math.fmod(get_var(obj, "ai_timer"), 5) == 0 and get_var(obj, "spawn_things") > 0) then
                play_sound_ext(get_asset("snd_thunk"), 1.5, 0.35, get_var(obj, "x"))
                local bullet_amount = 180
                local delay_amount = 20

                if hard_mode then
                    delay_amount = 25
                    bullet_amount = 120
                end

                for i = 0, 350, bullet_amount do
                    local thorns = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(get_var(obj, "delayer") + i) * 2, rot_y(get_var(obj, "delayer") + i) * 2, get_asset("spr_bullet_generic_nega"))
        
                    set_var(thorns, "image_angle", call_function("point_direction", {0, 0, get_var(thorns, "hspeed"), get_var(thorns, "vspeed")}))
                    set_var(thorns, "ignore_walls", true)
    
                end
                set_var(obj, "delayer", get_var(obj, "delayer") + delay_amount)
                set_var(obj, "spawn_things", get_var(obj, "spawn_things") - 1)
            end
        end

        if (get_var(obj, 'ai_timer') >= 450 and get_var(obj, "ai_timer") < 480) then
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 120, 0.05) - get_var(obj, "x"))
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 120, 0.05) - get_var(obj, "y"))
        end
        if (get_var(obj, "ai_timer") >= 480) then
            ChangeState(obj, {EntropyStates.SideDecay, EntropyStates.WavyThorns, EntropyStates.RingleaderSpeen, EntropyStates.DecayTornado})
        end
    end

    if (get_var(obj, "state") == EntropyStates.RingleaderSpeen) then
        local decay_explode = function(v)
            init_var(v, "boom_timer", 0)

            if (get_var(v, "boom_timer") == 60) then
                play_sound_ext(get_asset("snd_mech"), 1, 1, get_var(v, "x"))
                spawn_particle(get_var(v, "x"), get_var(v, "y"), 0, 0, get_asset("spr_spoopy_explosion"))

                local bullet_amount = 120

                if hard_mode then
                    bullet_amount = 90
                end

                init_var(v, "boom_rando", math.random(0, 359))
                add_screenshake(5)
                for i = 0, 350, bullet_amount do
                    local diamond = spawn_projectile(get_var(v, "x"), get_var(v, "y"), rot_x(i + get_var(v, "boom_rando")), rot_y(i + get_var(v, "boom_rando")), get_asset("spr_enemy_bullet_diamond_nega"))
                    set_var(diamond, "image_angle", call_function("point_direction", {0, 0, get_var(diamond, "hspeed"), get_var(diamond, "vspeed")}))
                    set_var(diamond, "ignore_walls", true)
                end
                call_function("instance_destroy", {v})
            end

            set_var(v, "boom_timer", get_var(v, "boom_timer") + 1)
        end
    
        local orbitlets_decay = function(v)
            init_var(v, "radius", 0)
            init_var(v, "spin", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))
            init_var(v, "spin_rate", 0)

            set_var(v, "x", get_var(v, "initial_x") + get_var(v, "radius") * rot_x(get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") + get_var(v, "radius") * rot_y(get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "spin", get_var(v, "spin") + get_var(v, "spin_rate"))
            set_var(v, "spin_rate", get_var(v, "spin_rate") + 0.1)
            set_var(v, "radius", lerp(get_var(v, "radius"), 50, 0.05))
        end
        
        if (get_var(obj, "ai_timer") == 0) then
            set_var(obj, "siner", 30)
            init_var(obj, "random_chosen", math.random(50, 190))
        end

        if (get_var(obj, "ai_timer") < 20) then
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 120, 0.1) - get_var(obj, "x"))
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 120, 0.1) - get_var(obj, "y"))
        end

        if (get_var(obj, "ai_timer") < 240 and get_var(obj, "ai_timer") >= 20) then
            set_var(obj, "vspeed", math.sin(get_var(obj, "siner") / 25))
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + get_var(obj, 'random_chosen'), 0.01) - get_var(obj, "x"))
        end

        if (math.fmod(get_var(obj, "ai_timer"), 60) == 0 and get_var(obj, "ai_timer") < 240) then

            play_sound(get_asset("snd_heartbeat"), get_var(obj, "x"))
            for i = 0, 350, 45 do
                local decays = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i), rot_y(i), decay_sprite)
                LumHelp.AddCallback(decays, orbitlets_decay)
                LumHelp.AddCallback(decays, decay_rotator)
                LumHelp.AddCallback(decays, decay_explode)

                set_var(decays, "image_angle", math.random(0, 359))
                set_var(decays, "ignore_walls", true)

                init_var(decays, "spin_offset", 0)

                set_var(decays, "spin_offset", get_var(decays, "spin_offset") + i)
            end
        end

        if (get_var(obj, "ai_timer") == 240) then
            play_sound(get_asset("snd_dash_super"), get_var(obj, "x"))
        end

        if (get_var(obj, "ai_timer") >= 240 and get_var(obj, "ai_timer") < 260) then
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 120, 0.1) - get_var(obj, "x"))
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 120, 0.1) - get_var(obj, "y"))
        end

        if (get_var(obj, "ai_timer") >= 260) then
            ChangeState(obj, {EntropyStates.ThornSlash, EntropyStates.SideDecay, EntropyStates.WavyThorns})
        end

    end

    if (get_var(obj, "state") == EntropyStates.DecayTornado) then

        local bullet_faller = function(v)
            set_var(v, "vspeed", clamp(get_var(v, "vspeed"), -2, 6) + 0.1)
        end

        local decay_twins_bullets = function(v)
            init_var(v, "spew_timer", 0)
            local random_speed = math.random(-1, 1)
            local time_to_spew = 20
            if hard_mode then
                time_to_spew = 20
            end

            if (math.fmod(get_var(v, "spew_timer"), time_to_spew) == 0 and get_var(v, "x") < view_x + 240 and get_var(v, "x") > view_x) then
                local coil = spawn_projectile(get_var(v, "x"), get_var(v, "y"), random_speed, -4, get_asset("spr_bullet_coil"))

                set_var(coil, "ignore_walls", true)
                LumHelp.AddCallback(coil, bullet_faller)
            end

            set_var(v, "spew_timer", get_var(v, "spew_timer") + 1)
        end


        local decay_twins_spewer = function(v)
            init_var(v, "spin", 0)
            init_var(v, "radius", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))
            init_var(v, "spin_rate", 0)
            init_var(v, "follower", 0)
            init_var(v, "follower_speed", 3)

            local spin_rate_difficulty = 0.1
            local max_spin_speed = -10
            if hard_mode then
                spin_rate_difficulty = 0.2
                max_spin_speed = -15
            end

            set_var(v, "x", get_var(v, "initial_x") - get_var(v, "follower") + get_var(v, "radius") * rot_x(get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") + get_var(v, "radius") * rot_y(get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "follower", get_var(v, "follower") - get_var(v, "follower_speed"))
            set_var(v, "follower_speed", lerp(get_var(v, 'follower_speed'), -4, 0.02))

            set_var(v, "spin", get_var(v, "spin") + get_var(v, "spin_rate"))
            set_var(v, "spin_rate", clamp(get_var(v, "spin_rate"), max_spin_speed, 0) - spin_rate_difficulty)
            set_var(v, "radius", lerp(get_var(v, "radius"), 50, 0.05))
        end

        if (get_var(obj, "ai_timer") == 1) then
            play_sound(get_asset("snd_dash_super"), get_var(obj, "x"))
        end

        if (get_var(obj, "ai_timer") < 20) then
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 80, 0.25) - get_var(obj, "x"))
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 100, 0.25) - get_var(obj, "y"))
        end

        if (get_var(obj, "ai_timer") == 20) then
            play_sound(get_asset("snd_heartbeat"), get_var(obj, "x"))
            local decay_amount = 180
            if hard_mode then
                decay_amount = 120
            end

            for i = 0, 350, decay_amount do
                local decay_twins = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), 0, -2, decay_sprite)
                init_var(decay_twins, "spin_offset", i)
                
                set_var(decay_twins, "ignore_walls", true)
                set_var(decay_twins, "image_angle", math.random(0, 359))
                set_var(decay_twins, "nobreak", true)

                LumHelp.AddCallback(decay_twins, decay_rotator)
                LumHelp.AddCallback(decay_twins, decay_twins_spewer)
                LumHelp.AddCallback(decay_twins, decay_twins_bullets)
            end
            set_var(obj, "siner", 30)
        end

        if (math.fmod(get_var(obj, "ai_timer"), 120) == 0 and get_var(obj, "ai_timer") >= 20 and get_var(obj, "ai_timer") < 320) then

            local decay_amount = 180
            if hard_mode then
                decay_amount = 120
            end
            play_sound(get_asset("snd_heartbeat"), get_var(obj, "x"))
            for i = 0, 350, decay_amount do
                local decay_twins = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), 0, -2, decay_sprite)
                init_var(decay_twins, "spin_offset", i)
                
                set_var(decay_twins, "ignore_walls", true)
                set_var(decay_twins, "image_angle", math.random(0, 359))
                set_var(decay_twins, "nobreak", true)

                LumHelp.AddCallback(decay_twins, decay_rotator)
                LumHelp.AddCallback(decay_twins, decay_twins_spewer)
                LumHelp.AddCallback(decay_twins, decay_twins_bullets)
            end
        end

        if (get_var(obj, "ai_timer") >= 20 and get_var(obj, "ai_timer") < 320) then
            set_var(obj, "hspeed", math.sin(get_var(obj, "siner") / 150))
            set_var(obj, "vspeed", lerp(get_var(obj, "vspeed"), 0.1, 0.1))
        end

        if (get_var(obj, "ai_timer") >= 320) then
            set_var(obj, "hspeed", get_var(obj, "hspeed") * 0.85)
            set_var(obj, "vspeed", get_var(obj, "vspeed") * 0.85)
        end
        if (get_var(obj, "ai_timer") == 340) then
            ChangeState(obj, {EntropyStates.SideDecay, EntropyStates.ThornSlash, EntropyStates.WavyThorns})
        end
    end

    if (get_var(obj, "state") == EntropyStates.Dead) then
        init_var(obj, "dead_timer", 0)

        if (get_var(obj, "dead_timer") <= 1) then
            clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
        end

        if (get_var(obj, "dead_timer") == 1) then
            play_sound(get_asset("snd_heavy_hit"), get_var(obj, "x"))
        end

        if (get_var(obj, "dead_timer") < 10) then
            set_var(obj, "hspeed", get_var(obj, "hspeed") * 0.9)
            set_var(obj, "vspeed", get_var(obj, "vspeed") * 0.9)
        end

        if (get_var(obj, "dead_timer") >= 10 and get_var(obj, "dead_timer") < 60) then
            if (math.fmod(get_var(obj, "dead_timer"), 5) == 0) then
                add_screenshake(5)
                play_sound(get_asset("snd_thunk"), get_var(obj, "x"))
                local random_speed = math.random(0, 359)

                local death_decay = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(random_speed) * 3, rot_y(random_speed) * 3, decay_sprite)

                set_var(death_decay, "damage", 0)
                set_var(death_decay, "ignore_walls", true)
                set_var(death_decay, "image_angle", math.random(0, 359))

                LumHelp.AddCallback(death_decay, decay_rotator)
            end
        end

        if (get_var(obj, "dead_timer") == 60) then
            play_sound(get_asset("snd_boom"), get_var(obj, "x"))
            add_screenshake(15)
            clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
            call_function("instance_destroy", {obj})
        end

        set_var(obj, "dead_timer", get_var(obj, "dead_timer") + 1)
    end


    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end


register_data(entropy)