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
        boss_message(120, 80, "wisp")
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
    set_var(obj, "pass_wall", 1)
    set_var(obj, "hp_damage", 500)
    set_var(obj, "state", "INTRO")
    set_var(obj, "ai_timer", 0)
end


StarStates = {
    Intro = "INTRO",
    StarSucc = "STARSUCC", --Attacks similarly to Database's rings attack, but moves up and down while doing it
    StarStorm = "STARSTORM",
    StarSpiral = "STARSPIRAL",
    Dead = "DED"
}

function ChangeState(obj, states)
    set_var(obj, "ai_timer", 0)
    local state = states[math.random(1, #states)]
    set_var(obj, "state", state)
end


function star.Draw(obj)

    if (math.fmod(get_var(obj, "ai_timer"), 6) == 0) then
        local sp = spawn_particle(get_var(obj, "x"), get_var(obj, "y"), 0, 0, star_sprite)

        set_var(sp, "image_alpha", 0.5)
        set_var(sp, "image_xscale", 0.5)
        set_var(sp, "image_yscale", 0.5)


        local fader = function(v)
            set_var(v, "image_alpha", get_var(v, "image_alpha") - 0.01)
            set_var(v, "image_xscale", get_var(v, "image_xscale") - 0.01)
            set_var(v, "image_yscale", get_var(v, "image_yscale") - 0.01)
            if (get_var(v, "image_alpha") <= 0) then
                call_function("instance_destroy", {v})
            end
        end
        LumHelp.AddCallback(sp, fader)
    end
end


function star.Step(obj)

    local shrinker = function(v)
        set_var(v, "image_xscale", lerp(get_var(v, "image_xscale"), 0.75, 0.1))
        set_var(v, "image_yscale", lerp(get_var(v, "image_yscale"), 0.75, 0.1))
    end

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
        set_var(obj, "state", StarStates.StarSpiral)
    end

    if (get_var(obj, "state") == StarStates.StarSucc) then
        
        set_var(obj, "image_angle", lerp(get_var(obj, "image_angle"), 0, 0.35 * 0.35))

        if (get_var(obj, "ai_timer") < 30) then
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 150, 0.2) - get_var(obj, "y"))
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 120, 0.2) - get_var(obj, "x"))
        end

        if (get_var(obj, "ai_timer") >= 30) then

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
                    LumHelp.AddCallback(star_stop, shrinker)
                    spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), -rot_x(i + get_var(obj, "spin_rando") + loop_offset) * 1.5, -rot_y(i + get_var(obj, "spin_rando") + loop_offset) * 1.5, get_asset("spr_enemy_bullet_dstar_blue"))
                end
                if hard_mode then
                    for i = 1, 350, 60 do
                        spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + get_var(obj, "spin_rando")), rot_y(i + get_var(obj, "spin_rando")), get_asset("spr_blinkbullet"))
                    end
                end
            end
            
        end

        if (get_var(obj, "ai_timer") == 280) then
            ChangeState(obj, {StarStates.StarStorm, StarStates.StarSpiral})
        end
    end

    if (get_var(obj, "state") == StarStates.StarStorm) then
        set_var(obj, "image_angle", lerp(get_var(obj, "image_angle"), 0, 0.35 * 0.35))

        if (get_var(obj, "ai_timer") < 100) then
            local random_shake = math.random(-2, 2)
            set_var(obj, "hspeed", random_shake)

            local star_scatter = math.random(-180, 0)

            if (math.fmod(get_var(obj, "ai_timer"), 10) == 0) then
                set_var(obj, "hspeed", 0)
                local bul = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(star_scatter), rot_y(star_scatter), get_asset("spr_bullet_coil"))
                if hard_mode then
                    local speed_randomizer = math.random(-1, 1)
                    spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), 1, speed_randomizer, get_asset("spr_tribullet"))
                    spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), -1, speed_randomizer, get_asset("spr_tribullet"))
                end
                set_var(obj, "vspeed", get_var(obj, "vspeed") - 0.5)
                set_var(bul, "ignore_walls", true)
            end
        end

        local decide_smash_location = math.random(20, 200)

        if (get_var(obj, "ai_timer") == 100) then
            set_var(obj, "hspeed", 0)
            set_var(obj, "vspeed", 0)
            set_var(obj, "y", view_y)
        elseif (get_var(obj, "ai_timer") == 110) then
            for i = 0, 240, 20 do
                spawn_particle(view_x + decide_smash_location - 20, view_y + i + 20, 0, 0, get_asset("spr_danger_new"))
                spawn_particle(view_x + decide_smash_location, view_y + i + 20, 0, 0, get_asset("spr_danger_new"))
                spawn_particle(view_x + decide_smash_location + 20, view_y + i + 20, 0, 0, get_asset("spr_danger_new"))
                set_var(obj, "smash_location", decide_smash_location)
            end
        end

        if (get_var(obj, "ai_timer") == 120) then
            set_var(obj, "x", get_var(obj, "smash_location") + view_x)
            set_var(obj, "vspeed", 5)
        elseif (get_var(obj, "y") == view_y + 260) then
            play_sound(get_asset("snd_wham"), get_var(obj, "x"), get_var(obj, "y"))
            play_sound(get_asset("snd_clatter"), get_var(obj, "x"), get_var(obj, "y"))

            add_screenshake(15)
            for i = 0, 350, 30 do
                local star_wall = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i) * 2, rot_y(i) * 2, get_asset("spr_enemy_bullet_dstar"))
                set_var(star_wall, "ignore_walls", true)
            end
            if (hard_mode) then
                local dopplers = 30
                local loop_rotation = 15

                if (get_global("game_loop") >= 5) then
                    dopplers = 20
                    loop_rotation = 0
                end

                for i = 0, 350, dopplers do
                    local star_wall = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + loop_rotation), rot_y(i + loop_rotation), get_asset("spr_bullet_dopple_blue"))
                    set_var(star_wall, "image_angle", call_function("point_direction", {0, 0, get_var(star_wall, "hspeed"), get_var(star_wall, "vspeed")}))
                    set_var(star_wall, "ignore_walls", true)
                end
            end
            set_var(obj, "vspeed", -6)
        end

        if (get_var(obj, "ai_timer") >= 178 and get_var(obj, "ai_timer") < 210) then
            set_var(obj, "vspeed", get_var(obj, "vspeed") * 0.9)
        elseif (get_var(obj, "ai_timer") >= 210) then
            ChangeState(obj, {StarStates.StarSucc, StarStates.StarSpiral})
        end

    end

    if (get_var(obj, "state") == StarStates.StarSpiral) then

        if (get_var(obj, "ai_timer") < 20) then
            set_var(obj, "vspeed", lerp(get_var(obj, "y"), view_y + 150, 0.2) - get_var(obj, "y"))
            set_var(obj, "hspeed", lerp(get_var(obj, "x"), view_x + 110, 0.2) - get_var(obj, "x"))
        end

        if (get_var(obj, "ai_timer") >= 20 and get_var(obj, "ai_timer") < 190) then
            set_var(obj, "image_angle", get_var(obj, "image_angle") + 2)


            set_var(obj, "vspeed", math.sin(get_var(obj, "siner") / 25))
            set_var(obj, "hspeed", -math.cos(get_var(obj, "siner") / 25))


            if (math.fmod(get_var(obj, "ai_timer"), 10) == 0) then
                init_var(obj, "rotator", 0)
                local spiral_amount = 180

                if hard_mode then
                    spiral_amount = 120
                end
                play_sound(get_asset("snd_fireball_fire"), get_var(obj, "x"))

                for i = 0, 350, spiral_amount do
                    local proj = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + get_var(obj, "rotator")), rot_y(i + get_var(obj, "rotator")), get_asset("spr_bullet_dopple_red"))
                    set_var(proj, "image_angle", call_function("point_direction", {0, 0, get_var(proj, "hspeed"), get_var(proj, "vspeed")}))
                end
                set_var(obj, "rotator", get_var(obj, "rotator") + 12)
            end
        end
        if (get_var(obj, "ai_timer") == 190) then
            set_var(obj, "vspeed", 0)
            set_var(obj, "hspeed", 0)
            ChangeState(obj, {StarStates.StarSucc, StarStates.StarStorm})
        end

    end

    if (get_var(obj, "state") == StarStates.Dead) then
        set_var(obj, "hspeed", 0)
        set_var(obj, "vspeed", 0)
        set_var(obj, "ai_timer", 0)
    end
    

    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end


register_data(star)