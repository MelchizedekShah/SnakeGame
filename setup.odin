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


init :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOWS_SIZE, WINDOWS_SIZE, "Snake")
	rl.InitAudioDevice()
}

cleanup_1 :: proc(assets: Single_Assets) {
	rl.UnloadTexture(assets.head1_sprite)
	rl.UnloadTexture(assets.body1_sprite)
	rl.UnloadTexture(assets.tail1_sprite)
	rl.UnloadTexture(assets.food1_sprite)

	// Sounds
	rl.UnloadSound(assets.eat)
	rl.UnloadSound(assets.crash)
}

cleanup_2 :: proc(assets: Double_Assets) {
	// snake 2
	rl.UnloadTexture(assets.head2_sprite)
	rl.UnloadTexture(assets.body2_sprite)
	rl.UnloadTexture(assets.tail2_sprite)
	rl.UnloadTexture(assets.food2_sprite)

	// From single
	rl.UnloadTexture(assets.head1_sprite)
	rl.UnloadTexture(assets.body1_sprite)
	rl.UnloadTexture(assets.tail1_sprite)
	rl.UnloadTexture(assets.food1_sprite)

	// Sounds
	rl.UnloadSound(assets.eat)
	rl.UnloadSound(assets.crash)
	rl.UnloadSound(assets.grow)
	rl.UnloadSound(assets.shrink)
}


close_game :: proc() {
	rl.CloseAudioDevice()
	rl.CloseWindow()
}
