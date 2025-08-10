local vector = require("REALMdotEXE/libraries/vector")


star_cloak_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/StarCloak-Sheet.png", 4, 20, 30, 30)
ares_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/AresFace.png", 1, 20, 30, 20)
aphrodite_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/AphroditeFace.png", 1, 20, 30, 20)
hestia_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/HestiaFace.png", 1, 20, 30, 20)
apollo_sprite = custom_sprite("REALMdotEXE/enemies/bosses/luminescence/ApolloFace.png", 1, 20, 30, 20)




Stars = {Ares = "ARES", Aphrodite = "APHRODITE", Hestia = "HESTIA", Apollo = "APOLLO"}

AphroditeStates = {
    HomingSpin = "APHRO_HOMINGSPIN"
}



luminescence = enemy_data("star_warden")


luminescence.Boss = true


function luminescence.BossIntro(obj)
    init_var(obj, "boss_timer", 0)

    if (get_var(obj, "boss_timer") == 0) then
        spawn_enemy(view_x + 120, view_y + 120, "star_warden")
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
    set_var(obj, "current_star", Stars.Aphrodite)
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
        
    elseif (star_count == 1) then
        set_var(obj, "hp", 250)
        set_var(obj, "maxhp", 250)
        set_var(obj, "hp_damage", 250)
        set_var(obj, "ai_timer", 0)
        set_var(obj, "behavior", "default")
        set_var(obj, "current_star", Stars.Apollo)
        set_var(obj, "mask_index", star_cloak_sprite)
    end
end


function luminescence.Draw(obj)
    set_var(obj, "image_alpha", 0)
    draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), star_cloak_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)

    if (get_var(obj, "current_star") == Stars.Ares) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), ares_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    end
    if (get_var(obj, "current_star") == Stars.Aphrodite) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), aphrodite_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    end
    if (get_var(obj, "current_star") == Stars.Apollo) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), apollo_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
    end
    if (get_var(obj, "current_star") == Stars.Hestia) then
        draw_sprite_ext(get_var(obj, "x"), get_var(obj, "y"), hestia_sprite, 0, 0, 1, 1, create_color(255, 255, 255), 1)
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
        if (get_var(obj, "ai_timer") == 15) then
            if (get_var(obj, "current_star") == Stars.Aphrodite) then
                ChangeState(obj, {AphroditeStates.HomingSpin})
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
                local MAX_SPEED = 3
                local MAX_FORCE = 0.05
    
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
    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end


register_data(luminescence)

