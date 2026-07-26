package snake

import rl "vendor:raylib"

run_single_player :: proc() {
	snake_blue: Snake
	snake_blue.direction.tick_timer = TICK_RATE

	restart_snake(&snake_blue)

	assets := Assets {
		food_sprite = rl.LoadTexture("food.png"),
		head_sprite = rl.LoadTexture("snake_head.png"),
		tail_sprite = rl.LoadTexture("snake_tail.png"),
		body_sprite = rl.LoadTexture("snake_body.png"),
		crash       = rl.LoadSound("crash.wav"),
		eat         = rl.LoadSound("eat.wav"),
	}

	defer cleanup(assets)

	game_loop: for !rl.WindowShouldClose() {
		// Snkae movement	
		snake_movement(&snake_blue, assets)
		rl.BeginDrawing()
		rl.ClearBackground(GAME_BACKROUND)

		camera := rl.Camera2D {
			zoom = f32(WINDOWS_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		// draw snake
		if !snake_blue.game_over {

			draw_snake(snake_blue, assets)
			draw_score(&snake_blue)

			rl.EndMode2D()
			rl.EndDrawing()
		} else {
			rl.EndMode2D()

			switch {
			case rl.IsKeyPressed(.M):
				break game_loop
			// restart_snake(&snake_blue)
			// gm = .Menu
			// menu_picker()
			// case rl.IsKeyPressed(.Q):
			// break game_loop
			// os.exit(0)
			//
			}

			write_text("Gave Over!", 150, "Press Enter to play again", "Press M for menu", 50)
			rl.EndDrawing()

		}
		free_all(context.temp_allocator)
	}
}
