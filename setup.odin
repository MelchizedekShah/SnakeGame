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

	assets := Assets {
		food2_sprite = rl.LoadTexture("textures/food.png"),
		food1_sprite = rl.LoadTexture("textures/coin.png"),
		head1_sprite = rl.LoadTexture("textures/snake_blue_head.png"),
		tail1_sprite = rl.LoadTexture("textures/snake_blue_tail.png"),
		body1_sprite = rl.LoadTexture("textures/snake_blue_body.png"),
		head2_sprite = rl.LoadTexture("textures/snake_pink_head.png"),
		tail2_sprite = rl.LoadTexture("textures/snake_pink_tail.png"),
		body2_sprite = rl.LoadTexture("textures/snake_pink_body.png"),
		crash        = rl.LoadSound("sounds/crash.wav"),
		eat          = rl.LoadSound("sounds/eat.wav"),
		grow         = rl.LoadSound("sounds/grow.wav"),
		shrink       = rl.LoadSound("sounds/shrink.wav"),
	}

	return assets
}

// cleanup_1 :: proc(assets: Single_Assets) {
// 	rl.UnloadTexture(assets.head1_sprite)
// 	rl.UnloadTexture(assets.body1_sprite)
// 	rl.UnloadTexture(assets.tail1_sprite)
// 	rl.UnloadTexture(assets.food1_sprite)
//
// 	// Sounds
// 	rl.UnloadSound(assets.eat)
// 	rl.UnloadSound(assets.crash)
// }

cleanup :: proc(assets: Assets) {
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
