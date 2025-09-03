fake_dream_death_sprite = custom_sprite("REALMdotEXE/enemies/bosses/DI.png", 1, 16, 16, 0)
fake_dream_star_sprite = custom_sprite("REALMdotEXE/enemies/bosses/star_creature/star_creature.png", 1, 24, 27, 0)

fake_dream = enemy_data("fake_dream")

fake_dream.Boss = true

function fake_dream.Create(obj)
    set_var(obj, "sprite_index", get_asset("spr_nothing"))
    set_var(obj, "hp", 15)
    set_var(obj, "maxhp", 15)
    set_var(obj, "hp_damage", 15)
    set_var(obj, "state", "CHOICE")
    set_var(obj, "ai_timer", 0)
    set_var(obj, "skiphpbar", true)
end


function fake_dream.BossIntro(obj)
    init_var(obj, "boss_timer", 0)
    if (get_var(obj, "boss_timer") == 1) then
        spawn_enemy(view_x + 120, view_y + 120, "fake_dream")
    end
    set_var(obj, "boss_timer", get_var(obj, "boss_timer") + 1)
end


function fake_dream.Draw(obj)
    if (get_var(obj, "state") == "CHOICE") then
        draw_sprite(view_x + 60, view_y + 120, fake_dream_death_sprite, 0)
        draw_sprite(view_x + 180, view_y + 120, fake_dream_star_sprite, 0)
    end
end


function fake_dream.Step(obj)
    if (get_var(obj, "behavior") == "dead") then
        init_var(obj, "dead_timer", 0)

        if (get_var(obj, "dead_timer") == 0) then
            clear_bullets(get_var(obj, "x"), get_var(obj, "y"))
        end
        if (get_var(obj, "dead_timer") == 2) then
            call_function("instance_destroy", {obj})
        end
        set_var(obj, "dead_timer", get_var(obj, "dead_timer") + 1)
    end

    if (get_var(obj, "state") == "CHOICE") then
        
        if (player_x < view_x + 60 + 5 or player_x > view_x + 60 - 5 and player_y < view_y + 120 + 5 or player_y > view_y + 120 - 5 and not get_var(obj, "state") == "FIGHT") then
            set_var(obj, "state", "FIGHT")
            print("death")
            spawn_boss_intro(view_x + 120, view_y + 120, "death_incarnate")
        end
        if (player_x > view_x + 180 + 5 or player_x < view_x + 180 - 5 and player_y < view_y + 120 - 5 or player_y > view_y + 120 + 5 and not get_var(obj, "state") == "FIGHT") then
            set_var(obj, "state", "FIGHT")
            print("wisp")
            spawn_boss_intro(view_x + 120, view_y + 120, "star_boss")
        end
    end

    set_var(obj, "ai_timer", get_var(obj, "ai_timer") + 1)
end

register_data(fake_dream)
