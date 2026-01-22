local vector = require("REALMdotEXE/libraries/vector")
local tweenEase = require("REALMdotEXE/libraries/easing")


local star_cloak_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/StarCloak-Sheet.png", 4, 20, 30, 30)
local ares_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/AresFace.png", 1, 20, 30, 20)
local aphrodite_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/AphroditeFace.png", 1, 20, 30, 20)
local hestia_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/HestiaFace.png", 1, 20, 30, 20)
local apollo_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/ApolloFace.png", 1, 20, 30, 20)




Stars = {Ares = "ARES", Aphrodite = "APHRODITE", Hestia = "HESTIA", Apollo = "APOLLO"}

AphroditeStates = {
    HomingSpin = "APHRO_HOMINGSPIN"
}

ApolloStates = {
    TeleportSpam = "APOLLO_TELEPORTSPAM"
}

AresStates = {
    MinionSploder = "ARES_MINIONSPLODER"
}



luminescence = enemy_data("star_warden")


luminescence.Boss = true


function luminescence.BossIntro(obj)
    init_var(obj, "boss_timer", 0)

    if (get_var(obj, "boss_timer") == 0) then
        spawn_object(view_x + 120, view_y + 120, "star_warden")
        play_music(get_asset("mus_divine_might"))
    end

    set_var(obj, "boss_timer", get_var(obj, "boss_timer") + 1)
end

star_indexes = {"ARES", "HESTIA", "APHRODITE"}

function luminescence.Create(obj)
    set_var(obj, "sprite_index", star_cloak_sprite)
    set_var(obj, "hp", 250)
    set_var(obj, "maxhp", 250)
    set_var(obj, "hp_damage", 250)
    set_var(obj, "state", "INTRO")
    set_var(obj, "ai_timer", 0)
    set_var(obj, "damage", 0)
    --set_var(obj, "current_star", Stars.Ares)
    SwitchStars(obj)
end

function ChangeState(obj, states)
    set_var(obj, "ai_timer", 0)
    local state = states[math.random(1, #states)]
    set_var(obj, "state", state)
end

function SwitchStars(obj)
    local star_count = 1
    shuffle(star_indexes)

    for i, v in ipairs(star_indexes) do
        star_count = star_count + 1
    end

    if (star_count > 1) then

        local picked_star = 1
        local star_index = star_indexes[picked_star]

        set_var(obj, "hp", 250)
        set_var(obj, "maxhp", 250)
        set_var(obj, "hp_damage", 250)
        set_var(obj, "ai_timer", 0)
        set_var(obj, "behavior", "default")
        set_var(obj, "mask_index", star_cloak_sprite)

        table.remove(star_indexes, picked_star)
        set_var(obj, "current_star", star_index)
        set_var(obj, "state", "INTRO")
        
    elseif (star_count == 1) then
        set_var(obj, "hp", 250)
        set_var(obj, "maxhp", 250)
        set_var(obj, "hp_damage", 250)
        set_var(obj, "ai_timer", 0)
        set_var(obj, "behavior", "default")
        set_var(obj, "current_star", Stars.Apollo)
        set_var(obj, "mask_index", star_cloak_sprite)
        set_var(obj, "state", "INTRO")
    end
end


function luminescence.Draw(obj)
    set_var(obj, "image_alpha", 0)
    init_var(obj, "cloak_xscale", 1)
    init_var(obj, "cloak_yscale", 1)
    init_var(obj, "eye_xscale", 1)
    init_var(obj, "eye_yscale", 1)

    draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), star_cloak_sprite, 0, 0, get_var(obj, "cloak_xscale"), get_var(obj, "cloak_yscale"), create_color(255, 255, 255), 1)

    if (get_var(obj, "current_star") == Stars.Ares) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), ares_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    end
    if (get_var(obj, "current_star") == Stars.Aphrodite) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), aphrodite_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    end
    if (get_var(obj, "current_star") == Stars.Apollo) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), apollo_sprite, 0, 0, get_var(obj, "eye_xscale"), get_var(obj, "eye_yscale"), create_color(255, 255, 255), 1)
    end
    if (get_var(obj, "current_star") == Stars.Hestia) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), hestia_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    end


    init_var(obj, "tween_timer", 0)

    if (get_var(obj, "state") == ApolloStates.TeleportSpam) then
        if (get_var(obj, "ai_timer") < 30) then
            init_var(obj, "cloak_init_xscale", get_var(obj, "cloak_xscale"))
            init_var(obj, "cloak_init_yscale", get_var(obj, "cloak_yscale"))

            local xStretcher = tweenEase.inBack(get_var(obj, "tween_timer"), 1, 0 - get_var(obj, "cloak_init_xscale"), 30)
            local yStretcher = tweenEase.inBack(get_var(obj, "tween_timer"), 1, 1.5 - get_var(obj, "cloak_init_yscale"), 30)

            set_var(obj, "cloak_xscale", clamp(xStretcher, 0, 3))
            set_var(obj, "cloak_yscale", clamp(yStretcher, 0, 3))
            set_var(obj, "eye_xscale", clamp(xStretcher, 0, 3))
            set_var(obj, "eye_yscale", clamp(yStretcher, 0, 3))
        end
        if (get_var(obj, "ai_timer") == 30) then
            set_var(obj, "cloak_xscale", 0)
            set_var(obj, "tween_timer", 0)
        end
        if (get_var(obj, "ai_timer") > 30 and get_var(obj, "ai_timer") < 65) then

            local end_time_x = get_var(obj, "cloak_xscale")
            local end_time_y = get_var(obj, "cloak_yscale")
            
            local xStretcher = tweenEase.outBack(get_var(obj, "tween_timer"), get_var(obj, "cloak_xscale"), 1 - end_time_x, 30)
            local yStretcher = tweenEase.outBack(get_var(obj, "tween_timer"), get_var(obj, "cloak_yscale"), 1 - end_time_y, 30)

            set_var(obj, "cloak_xscale", xStretcher)
            set_var(obj, "cloak_yscale", yStretcher)
            set_var(obj, "eye_xscale", xStretcher)
            set_var(obj, "eye_yscale", yStretcher)
        end
        set_var(obj, "tween_timer", get_var(obj, "tween_timer") + 1)
    end
end


function luminescence.Step(obj)
    if (get_var(obj, "behavior") == "dead" and get_var(obj, "current_star") == Stars.Apollo) then
        clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
        play_sound(get_asset("snd_boom"), view_x + 120)
        star_indexes = {"ARES", "HESTIA", "APHRODITE"}
        call_function("instance_destroy", {obj})
    elseif (get_var(obj, "behavior") == "dead") then
        clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
        SwitchStars(obj)
    end

    if (get_var(obj, "state") == "INTRO") then
        set_var(obj, "x", view_x + 120)
        set_var(obj, "y", view_y + 120)
        if (get_var(obj, "ai_timer") == 15) then
            if (get_var(obj, "current_star") == Stars.Aphrodite) then
                ChangeState(obj, {AphroditeStates.HomingSpin})
            end
            if (get_var(obj, "current_star") == Stars.Apollo) then
                ChangeState(obj, {ApolloStates.TeleportSpam})
            end
            if (get_var(obj, "current_star") == Stars.Ares) then
                ChangeState(obj, {AresStates.MinionSploder})
            end
        end
    end

    if (get_var(obj, "current_star") == Stars.Aphrodite) then
        local aphro_homing = function(v)
            init_var(v, "wait_homer", 0)

            if (get_var(v, "wait_homer") == 15) then
                play_sound(get_asset("snd_shing"), get_var(v, "x"))
            end

            if (get_var(v, "wait_homer") >= 15 and math.fmod(get_var(v, "wait_homer"), 2) == 0) then
                spawn_particle(get_var(v, "x"), get_var(v, "y"), math.random(-1, 1), math.random(-1, 1), get_asset("spr_small_stars_white"))
            end

            if (get_var(v, "wait_homer") >= 15) then
                local MAX_SPEED = 4.5
                local MAX_FORCE = 0.1
    
                local dir_vector = vector(get_var(v, "x"), get_var(v, "y"))
                local player_vector = vector(player_x, player_y)
                local velocity_vector = vector(get_var(v, "hspeed"), get_var(v, "vspeed"))
    
                local desired_vector = player_vector - dir_vector
                desired_vector:setmag(MAX_SPEED)
                local steering_vector = desired_vector - velocity_vector
                steering_vector:limit(MAX_FORCE)
    
                set_var(v, "vspeed", get_var(v, "vspeed") + steering_vector.y)
                set_var(v, "hspeed", get_var(v, "hspeed") + steering_vector.x)
                
            end
            set_var(v, "wait_homer", get_var(v, "wait_homer") + 1)
        end

        if (get_var(obj, "state") == AphroditeStates.HomingSpin) then
            if (math.fmod(get_var(obj, "ai_timer"), 5) == 0 and get_var(obj, "ai_timer") >= 10 and get_var(obj, "ai_timer") < 25) then
                play_sound(get_asset("snd_magic_shot"), get_var(obj, "x"))
                init_var(obj, "aphro_spin_offset", 0)
                for i = 0, 350, 180 do
                    local aphro_homer = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i + get_var(obj, "aphro_spin_offset")), rot_y(i + get_var(obj, "aphro_spin_offset")), get_asset("spr_bullet_homing_shot"))
                    LumHelp.AddCallback(aphro_homer, aphro_homing)
                end
                set_var(obj, "aphro_spin_offset", get_var(obj, "aphro_spin_offset") + 60)
            end
            if (get_var(obj, "ai_timer") >= 100) then
                ChangeState(obj, {AphroditeStates.HomingSpin})
            end
        end
    end

    if (get_var(obj, "current_star") == Stars.Ares) then
        local orbitlets = function(v)
            init_var(v, "spin", 0)
            init_var(v, "radius", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))
            init_var(v, "follower", 0)
            init_var(v, "follower_speed", 3)

            local spin_rate = 1
            if hard_mode then
                spin_rate = 1.5
            end

            set_var(v, "x", get_var(v, "initial_x") - get_var(v, "follower") + get_var(v, "radius") * rot_x(get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") + get_var(v, "follower") + get_var(v, "radius") * rot_y(get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "follower", get_var(v, "follower") - get_var(v, "follower_speed"))
            set_var(v, "follower_speed", lerp(get_var(v, 'follower_speed'), -3, 0.02))

            set_var(v, "spin", get_var(v, "spin") + spin_rate)
            set_var(v, "radius", get_var(v, "radius") + get_var(v, "radius_speed"))
        end

        local orbitletsinvert = function(v)
            init_var(v, "spin", 0)
            init_var(v, "radius", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))
            init_var(v, "follower", 0)
            init_var(v, "follower_speed", -3)

            local spin_rate = 1
            if hard_mode then
                spin_rate = 1.5
            end

            set_var(v, "x", get_var(v, "initial_x") - get_var(v, "follower") + get_var(v, "radius") * rot_x(get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") - get_var(v, "follower") + get_var(v, "radius") * rot_y(get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "follower", get_var(v, "follower") - get_var(v, "follower_speed"))
            set_var(v, "follower_speed", lerp(get_var(v, 'follower_speed'), 3, 0.02))

            set_var(v, "spin", get_var(v, "spin") + spin_rate)
            set_var(v, "radius", get_var(v, "radius") + get_var(v, "radius_speed"))
        end

        local exploder = function(v)
            init_var(v, "boom_time", 0)

            if (get_var(v, "boom_time") == 45) then
                init_var(v, "spin_rando", math.random(0, 359))
                init_var(v, "bullet_spin_offset", 0)

                for i = 0, 359, 36 do
                    local rotatinglets = spawn_projectile(get_var(v, "x"), get_var(v, "y"), rot_x(i + get_var(v, "spin_rando")), rot_y(i + get_var(v, "spin_rando")), get_asset("spr_bloodbullet"))
                    set_var(rotatinglets, "spin_offset", 0)
                    set_var(rotatinglets, "radius_speed", 1)
                    set_var(rotatinglets, "ignore_walls", true)
                    set_var(v, "bullet_spin_offset", get_var(v, "bullet_spin_offset") + 36)
                    set_var(rotatinglets, "spin_offset", get_var(v, "bullet_spin_offset"))
                    LumHelp.AddCallback(rotatinglets, orbitlets)
                end
                call_function("instance_destroy", {v})
            end

            set_var(v, "boom_time", get_var(v, "boom_time") + 1)
        end

        local exploderinvert = function(v)
            init_var(v, "boom_time", 0)

            if (get_var(v, "boom_time") == 45) then
                init_var(v, "spin_rando", math.random(0, 359))
                init_var(v, "bullet_spin_offset", 0)

                for i = 0, 359, 36 do
                    local rotatinglets = spawn_projectile(get_var(v, "x"), get_var(v, "y"), rot_x(i + get_var(v, "spin_rando")), rot_y(i + get_var(v, "spin_rando")), get_asset("spr_bloodbullet"))
                    set_var(rotatinglets, "spin_offset", 0)
                    set_var(rotatinglets, "radius_speed", 1)
                    set_var(rotatinglets, "ignore_walls", true)
                    set_var(v, "bullet_spin_offset", get_var(v, "bullet_spin_offset") + 36)
                    set_var(rotatinglets, "spin_offset", get_var(v, "bullet_spin_offset"))
                    LumHelp.AddCallback(rotatinglets, orbitletsinvert)
                end
                call_function("instance_destroy", {v})
            end

            set_var(v, "boom_time", get_var(v, "boom_time") + 1)
        end

        if (get_var(obj, "state") == AresStates.MinionSploder) then
            if (get_var(obj, "ai_timer") == 30) then
                local bomblet = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), 1, 0, get_asset("spr_enemy_bullet_medium_blood"))
                LumHelp.AddCallback(bomblet, exploder)
            end
            if (get_var(obj, "ai_timer") == 60) then
                local bomblet2 = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), -1, 0, get_asset("spr_enemy_bullet_medium_blood"))
                LumHelp.AddCallback(bomblet2, exploderinvert)
            end
            if (get_var(obj, "ai_timer") == 90) then
                set_var(obj, "ai_timer", 0)
                set_var(obj, "state", "INTRO")
            end
        end
    end

    if (get_var(obj, "current_star") == Stars.Apollo) then

        local orbitlets = function(v)
            init_var(v, "spin", 0)
            init_var(v, "radius", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))

            local spin_rate = 1
            if hard_mode then
                spin_rate = 1.5
            end

            set_var(v, "x", get_var(v, "initial_x") + get_var(v, "radius") * rot_x(get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") + get_var(v, "radius") * rot_y(get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "spin", get_var(v, "spin") + spin_rate)
            set_var(v, "radius", get_var(v, "radius") + get_var(v, "radius_speed"))
        end
        local invertlets = function(v)
            init_var(v, "spin", 0)
            init_var(v, "radius", 0)
            init_var(v, "initial_x", get_var(v, "x"))
            init_var(v, "initial_y", get_var(v, "y"))

            local spin_rate = 1
            if hard_mode then
                spin_rate = 1.5
            end

            set_var(v, "x", get_var(v, "initial_x") + get_var(v, "radius") * rot_x(-get_var(v, "spin") + get_var(v, "spin_offset")))
            set_var(v, "y", get_var(v, "initial_y") + get_var(v, "radius") * rot_y(-get_var(v, "spin") + get_var(v, "spin_offset")))

            set_var(v, "spin", get_var(v, "spin") + spin_rate)
            set_var(v, "radius", get_var(v, "radius") + get_var(v, "radius_speed"))
        end
        

        if (get_var(obj, "state") == ApolloStates.TeleportSpam) then
            if (get_var(obj, "ai_timer") == 30) then
                set_var(obj, "x", view_x + math.random(40, 180))
                set_var(obj, "y", view_y + math.random(80, 260))
            end
            if (get_var(obj, "ai_timer") == 80) then
                set_var(obj, "bullet_spin_offset", 0)
                for i = 0, 359, 30 do
                    local spinlet = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i), rot_y(i), get_asset("spr_bullet_coil_blue"))
                    init_var(spinlet, "spin_offset", 0)
                    init_var(spinlet, "radius_speed", 2)
                    set_var(spinlet, "ignore_walls", true)
                    set_var(obj, "bullet_spin_offset", get_var(obj, "bullet_spin_offset") + 30)
                    set_var(spinlet, "spin_offset", get_var(obj, "bullet_spin_offset"))
                    LumHelp.AddCallback(spinlet, orbitlets)
                end
                for i = 0, 359, 24 do
                    local spinlet = spawn_projectile(get_var(obj, "x"), get_var(obj, "y"), rot_x(i), rot_y(i), get_asset("spr_bullet_coil_blue"))
                    init_var(spinlet, "spin_offset", 0)
                    init_var(spinlet, "radius_speed", 1)
                    set_var(spinlet, "ignore_walls", true)
                    set_var(obj, "bullet_spin_offset", get_var(obj, "bullet_spin_offset") + 24)
                    set_var(spinlet, "spin_offset", get_var(obj, "bullet_spin_offset"))
                    LumHelp.AddCallback(spinlet, invertlets)
                end
            end
            if (get_var(obj, "ai_timer") == 120) then
                set_var(obj, "ai_timer", 0)
                set_var(obj, "tween_timer", 0)
                set_var(obj, "x", view_x + 120)
                set_var(obj, "y", view_y + 120)
                ChangeState(obj, {ApolloStates.TeleportSpam})
            end
        end

    end

    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end


register_data(luminescence)

