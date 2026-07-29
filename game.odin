package snake

import rl "vendor:raylib"

run_single_player :: proc(assets: Assets) {
	snake_blue: Snake
	snake_blue.direction.tick_timer = TICK_RATE

	restart_snake(&snake_blue, {0, 1})


	game_loop: for !rl.WindowShouldClose() {
		// Snkae movement	
		single_snake_movement(&snake_blue, assets)
		rl.BeginDrawing()
		rl.ClearBackground(GAME_BACKROUND)

		camera := rl.Camera2D {
			zoom = f32(WINDOWS_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		// draw snake
		if !snake_blue.game_over {

			draw_snake(
				snake_blue,
				assets.head1_sprite,
				assets.body1_sprite,
				assets.tail1_sprite,
				assets.food1_sprite,
			)
			draw_score(&snake_blue, true, 0, rl.GRAY)

			rl.EndMode2D()
			rl.EndDrawing()
		} else {
			rl.EndMode2D()

			switch {
			case rl.IsKeyPressed(.M):
				break game_loop
			}

			write_text("Game Over!", 150, "Press Enter to play again", "Press M for menu", 50)
			rl.EndDrawing()

		}
		free_all(context.temp_allocator)
	}
}

run_double_player :: proc(assets: Assets) {
	snake_pink: Snake
	snake_blue: Snake

	snake_pink.direction.tick_timer = TICK_RATE
	snake_blue.direction.tick_timer = TICK_RATE

	restart_snake(&snake_pink, {0, 1}, DEFAULT_MANIPULATOR_POS)
	restart_snake(&snake_blue, {0, 1}, DEFAULT_MANIPULATOR_NEG)


	game_loop: for !rl.WindowShouldClose() {

		double_snake_movement(&snake_pink, &snake_blue, assets)

		rl.BeginDrawing()
		rl.ClearBackground(GAME_BACKROUND)

		camera := rl.Camera2D {
			zoom = f32(WINDOWS_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		// draw snake
		if !snake_blue.game_over && !snake_pink.game_over {

			draw_snake(
				snake_blue,
				assets.head1_sprite,
				assets.body1_sprite,
				assets.tail1_sprite,
				assets.food1_sprite,
			)
			draw_snake(
				snake_pink,
				assets.head2_sprite,
				assets.body2_sprite,
				assets.tail2_sprite,
				assets.food2_sprite,
			)

			draw_score(&snake_blue, false, 0, rl.BLUE)
			draw_score(&snake_pink, false, 250, rl.PINK)

			rl.EndMode2D()
			rl.EndDrawing()

		} else {
			rl.EndMode2D()

			switch {
			case rl.IsKeyPressed(.M):
				break game_loop
			}

			message: cstring

			switch {
			case snake_pink.game_over && snake_blue.game_over:
				message = "DRAW!"
			case snake_pink.game_over && !snake_blue.game_over:
				message = "BLUE WON!"
			case !snake_pink.game_over && snake_blue.game_over:
				message = "PINK WON!"
			}

			write_text(message, 150, "Press Enter to play again", "Press M for menu", 50)
			rl.EndDrawing()

		}
		free_all(context.temp_allocator)
	}
}
