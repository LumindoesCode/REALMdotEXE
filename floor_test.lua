customfloor = custom_floor("myFloor", "the evil")

floor_tileset = custom_sprite("REALMdotEXE/rooms/Tileset-Sheet.png", 30, 0, 0, 0)
floor_BGs = custom_sprite("REALMdotEXE/rooms/BGs-Sheet.png", 3, 0, 0, 0)
floor_song = custom_music("REALMdotEXE/level.ogg", "Divine Tragedy")

function customfloor.ShouldForceFloor()
    return true
end




customfloor.Floor = 2
customfloor.Music = floor_song
customfloor.Rooms = "REALMdotEXE/rooms/RunicLibrary.roo"
customfloor.RoomsID = "Mod_Test_TestingThings.roo"
customfloor.BossList = 10347
customfloor.Tileset = floor_tileset
customfloor.Backgrounds = floor_BGs
customfloor.ColorR = 0.3
customfloor.ColorG = 0
customfloor.ColorB = 0.15

register_data(customfloor)
