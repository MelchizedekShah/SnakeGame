package snake

import rl "vendor:raylib"

restart_snake :: proc(snake: ^Snake) {
	start_head_pos := Vec2i{GRID_WIDTH / 2, GRID_WIDTH / 2}
	snake.body[0] = start_head_pos
	snake.body[1] = start_head_pos - {0, 1}
	snake.body[2] = start_head_pos - {0, 2}
	snake.length = 3
	snake.game_over = false
	random_food(snake)
	snake.direction.move = {0, 1}
	snake.score.current = 0
}


snake_movement :: proc(snake: ^Snake, assets: Assets) {
	if !snake.direction.change_thick {
		switch {
		case rl.IsKeyPressed(.UP) && snake.direction.move != {0, 1}:
			snake.direction.move = {0, -1}
			snake.direction.change_thick = true

		case rl.IsKeyPressed(.DOWN) && snake.direction.move != {0, -1}:
			snake.direction.move = {0, 1}
			snake.direction.change_thick = true

		case rl.IsKeyPressed(.RIGHT) && snake.direction.move != {-1, 0}:
			snake.direction.move = {1, 0}
			snake.direction.change_thick = true

		case rl.IsKeyPressed(.LEFT) && snake.direction.move != {1, 0}:
			snake.direction.move = {-1, 0}
			snake.direction.change_thick = true
		}
	}; if snake.game_over {

		if rl.IsKeyPressed(.ENTER) {
			restart_snake(snake)
		}

	} else {
		snake.direction.tick_timer -= rl.GetFrameTime()
	}

	if snake.direction.tick_timer <= 0 {
		next_part_pos := snake.body[0]
		snake.body[0] += snake.direction.move
		snake.direction.change_thick = false
		head_pos := snake.body[0]

		if head_pos.x < 0 ||
		   head_pos.y < 0 ||
		   head_pos.x >= GRID_WIDTH ||
		   head_pos.y >= GRID_WIDTH {
			snake.game_over = true
			rl.PlaySound(assets.sound.crash)
		}

		for i in 1 ..< snake.length {
			cur_pos := snake.body[i]

			if cur_pos == head_pos {
				snake.game_over = true
				rl.PlaySound(assets.sound.crash)
			}

			snake.body[i] = next_part_pos
			next_part_pos = cur_pos
		}

		if head_pos == snake.food {
			snake.length += 1
			snake.body[snake.length - 1] = next_part_pos
			random_food(snake)
			rl.PlaySound(assets.sound.eat)
		}

		snake.direction.tick_timer = TICK_RATE + snake.direction.tick_timer
	}

}
