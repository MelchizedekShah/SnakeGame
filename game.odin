package snake

import rl "vendor:raylib"

run_single_player :: proc() {
	snake_blue: Snake
	snake_blue.direction.tick_timer = TICK_RATE

	restart_snake(&snake_blue, start_head_pos(0), {0, 1})

	assets := Single_Assets {
		food1_sprite = rl.LoadTexture("food.png"),
		head1_sprite = rl.LoadTexture("snake_blue_head.png"),
		tail1_sprite = rl.LoadTexture("snake_blue_tail.png"),
		body1_sprite = rl.LoadTexture("snake_blue_body.png"),
		crash        = rl.LoadSound("crash.wav"),
		eat          = rl.LoadSound("eat.wav"),
	}

	defer cleanup_1(assets)

	game_loop: for !rl.WindowShouldClose() {
		// Snkae movement	
		snake_movement(&snake_blue, assets.eat, assets.crash)
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
			draw_score(&snake_blue, 0, rl.GRAY)

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

			write_text("Game Over!", 150, "Press Enter to play again", "Press M for menu", 50)
			rl.EndDrawing()

		}
		free_all(context.temp_allocator)
	}
}

run_double_player :: proc() {
	snake_blue: Snake
	snake_pink: Snake
	snake_blue.direction.tick_timer = TICK_RATE
	snake_pink.direction.tick_timer = TICK_RATE

	restart_snake(&snake_blue, start_head_pos(-2), {0, 1})
	restart_snake(&snake_pink, start_head_pos(2), {0, -1})

	assets := Double_Assets {
		food1_sprite = rl.LoadTexture("coin.png"),
		head1_sprite = rl.LoadTexture("snake_blue_head.png"),
		tail1_sprite = rl.LoadTexture("snake_blue_tail.png"),
		body1_sprite = rl.LoadTexture("snake_blue_body.png"),
		food2_sprite = rl.LoadTexture("food.png"),
		head2_sprite = rl.LoadTexture("snake_pink_head.png"),
		tail2_sprite = rl.LoadTexture("snake_pink_tail.png"),
		body2_sprite = rl.LoadTexture("snake_pink_body.png"),
		crash        = rl.LoadSound("crash.wav"),
		eat          = rl.LoadSound("eat.wav"),
		grow         = rl.LoadSound("grow.wav"),
		shrink       = rl.LoadSound("shrink.wav"),
	}

	defer cleanup_2(assets)


	game_loop: for !rl.WindowShouldClose() {
		// Snkae movement	
		snakes_movement(
			&snake_pink,
			&snake_blue,
			assets.eat,
			assets.crash,
			assets.grow,
			assets.shrink,
		)
		rl.BeginDrawing()
		rl.ClearBackground(GAME_BACKROUND)

		camera := rl.Camera2D {
			zoom = f32(WINDOWS_SIZE) / CANVAS_SIZE,
		}
		rl.BeginMode2D(camera)

		// draw snake
		// if !snake_blue.game_over && !snake_pink.game_over {

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
		draw_score(&snake_blue, 0, rl.BLUE)
		draw_score(&snake_pink, 190, rl.PINK)

		rl.EndMode2D()
		rl.EndDrawing()
		// else {
		// rl.EndMode2D()

		// switch {
		// case rl.IsKeyPressed(.M):
		// break game_loop
		// restart_snake(&snake_blue)
		// gm = .Menu
		// menu_picker()
		// case rl.IsKeyPressed(.Q):
		// break game_loop
		// os.exit(0)
		//
		// }

		// write_text("Game Over!", 150, "Press Enter to play again", "Press M for menu", 50)
		// rl.EndDrawing()

	}
	free_all(context.temp_allocator)
}
// }
