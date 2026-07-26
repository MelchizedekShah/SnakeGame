package snake

import rl "vendor:raylib"

menu_picker :: proc() {

	for gm == .Menu && !rl.WindowShouldClose() {

		switch {
		case rl.IsKeyPressed(.ONE):
			gm = .SinglePlayer
		case rl.IsKeyPressed(.TWO):
			gm = .DoublePlayer
		}

		rl.BeginDrawing()

		write_text("SNAKE", 200, "Press 1 - Single Player", "Press 2 - Two Players", 50)

		rl.EndDrawing()
	}
}


init :: proc() -> Assets {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOWS_SIZE, WINDOWS_SIZE, "Snake")
	rl.InitAudioDevice()
	assets: Assets
	return assets
}

cleanup :: proc(assets: Assets) {
	rl.UnloadTexture(assets.head_sprite)
	rl.UnloadTexture(assets.body_sprite)
	rl.UnloadTexture(assets.tail_sprite)
	rl.UnloadTexture(assets.food_sprite)
	rl.UnloadSound(assets.eat)
	rl.UnloadSound(assets.crash)

}

close_game :: proc() {
	rl.CloseAudioDevice()
	rl.CloseWindow()
}
