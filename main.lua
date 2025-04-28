require("REALMdotEXE/libraries/math")
require("REALMdotEXE/libraries/callbacks")

FORCE_DEATH = false --set this to true to get a guaranteed death scout spawn
FORCE_STAR = false --set this to true to get a guaranteed star boss spawn

debug = global_data()



function debug.Step()
    if (call_function("keyboard_check_pressed", {call_function("ord", {"R"})}) == 1) then
        --spawn_boss_intro(view_x + 120, view_y + 120, "star_boss")
    end
    
    if (call_function("keyboard_check_pressed", {call_function("ord", {"L"})}) == 1) then
        --spawn_boss_intro(view_x + 120, view_y + 120, "death_incarnate")
    end
end

register_data(debug)


function mod_load()
    require("REALMdotEXE/enemies/bosses/death")
    require("REALMdotEXE/enemies/bosses/star_creature/star_creature")
end


function mod_unload()
    
end
