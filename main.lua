require("REALMdotEXE/libraries/math")
require("REALMdotEXE/libraries/callbacks")
require("REALMdotEXE/libraries/vector")

debug = global_data()

FORCE_DEATH = false
FORCE_STAR = false
FORCE_ENTROPY = false


function debug.Step()
    if (call_function("keyboard_check_pressed", {call_function("ord", {"R"})}) == 1) then
        --local cartridge = spawn_boss_intro(view_x + 120, view_y + 120, "hopeless_boss")
    end
    
    if (call_function("keyboard_check_pressed", {call_function("ord", {"P"})}) == 1) then
        --local thingo = call_function("ds_map_find_value", {get_global("current_floormap"), "music"})
        --print(thingo)
    end
end

register_data(debug)

function mod_load()
    --require("REALMdotEXE/floor_test")
    require("REALMdotEXE/enemies/bosses/death")
    require("REALMdotEXE/enemies/bosses/star_creature/star_creature")
    require("REALMdotEXE/enemies/bosses/entropy/entropy")
    --require("REALMdotEXE/enemies/bosses/lucid_dream_test")
    require("REALMdotEXE/enemies/decay")
    --require("REALMdotEXE/cartridge_test")
    --require("REALMdotEXE/enemies/bosses/luminescence/luminescence")
    --require("REALMdotEXE/enemies/star_ghost")
end


function mod_unload()
end
