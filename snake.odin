package snake

import rl "vendor:raylib"


wrap_vec2i :: proc(v: Vec2i, snake_length: ^int) -> Vec2i {
	wrap_coord :: proc(v: int) -> (int, bool) {
		if v < 0 {
			return GRID_WIDTH - 1, true
		}
		if v >= GRID_WIDTH {
			return 0, true
		}
		return v, false
	}

	x, wrap_x := wrap_coord(v.x)
	y, wrap_y := wrap_coord(v.y)

	if wrap_x || wrap_y {

		snake_length^ -= 1
	}

	return Vec2i{x, y}
}

calculate_direction :: proc(snake: Snake) -> Vec2i {
	direction: Vec2i
	switch snake.direction.move {
	case {0, 1}:
		direction = {0, -1}
	case {0, -1}:
		direction = {0, 1}
	case {1, 0}:
		direction = {-1, 0}
	case {-1, 0}:
		direction = {1, 0}
	}
	return direction
}

// Helper for restart_snake proc
start_head_pos :: proc(location_manipulator_x: int) -> Vec2i {
	return Vec2i{(GRID_WIDTH + location_manipulator_x) / 2, GRID_WIDTH / 2}
}

// restart_snake :: proc(
// 	snake: ^Snake,
// 	start_head_pos: Vec2i,
// 	dirction: Vec2i,
// 	snake_length := MIN_SNAKE_LENGTH,
// ) {
// 	snake.body[0] = start_head_pos
// 	snake.body[1] = start_head_pos - {0, 1}
// 	snake.body[2] = start_head_pos - {0, 2}
// 	snake.length = snake_length
// 	snake.game_over = false
//
// 	// debug
// 	fmt.println(snake.body[0])
// 	fmt.println(snake.body[1])
// 	fmt.println(snake.body[2])
//
// 	random_food(snake)
// 	snake.direction.move = dirction
// 	snake.score.current = 0
// }


restart_snake :: proc(
	snake: ^Snake,
	start_head_pos: Vec2i,
	direction: Vec2i,
	snake_length := MIN_SNAKE_LENGTH,
) {
	snake.direction.move = direction

	// Behind the head
	back := calculate_direction(snake^)

	snake.body[0] = start_head_pos

	for i in 1 ..< snake_length {
		snake.body[i] = start_head_pos + back * i
	}

	snake.length = snake_length
	snake.game_over = false
	snake.score.current = 0
	// for i in 0 ..< snake.length {
	// 	fmt.println(snake.body[i])
	// }
	random_food(snake)
}

snake_movement :: proc(snake: ^Snake, sound_eat: rl.Sound, sound_crash: rl.Sound) {
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
			// restart_snake(snake, {0, 1}, 0)
			restart_snake(snake, start_head_pos(0), {0, 1})

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
			rl.PlaySound(sound_crash)
		}

		for i in 1 ..< snake.length {
			cur_pos := snake.body[i]

			if cur_pos == head_pos {
				snake.game_over = true
				rl.PlaySound(sound_crash)
			}

			snake.body[i] = next_part_pos
			next_part_pos = cur_pos
		}

		if head_pos == snake.food {
			snake.length += 1
			snake.body[snake.length - 1] = next_part_pos
			random_food(snake)
			rl.PlaySound(sound_eat)
		}

		snake.direction.tick_timer = TICK_RATE + snake.direction.tick_timer
	}

}

snakes_movement :: proc(
	snake1: ^Snake,
	snake2: ^Snake,
	sound_eat: rl.Sound,
	sound_crash: rl.Sound,
	sound_grow: rl.Sound,
	sound_shrink: rl.Sound,
) {
	if !snake1.direction.change_thick {
		switch {
		case rl.IsKeyPressed(.UP) && snake1.direction.move != {0, 1}:
			snake1.direction.move = {0, -1}
			snake1.direction.change_thick = true

		case rl.IsKeyPressed(.DOWN) && snake1.direction.move != {0, -1}:
			snake1.direction.move = {0, 1}
			snake1.direction.change_thick = true

		case rl.IsKeyPressed(.RIGHT) && snake1.direction.move != {-1, 0}:
			snake1.direction.move = {1, 0}
			snake1.direction.change_thick = true

		case rl.IsKeyPressed(.LEFT) && snake1.direction.move != {1, 0}:
			snake1.direction.move = {-1, 0}
			snake1.direction.change_thick = true
		}
	}

	if !snake2.direction.change_thick {
		switch {
		case rl.IsKeyPressed(.W) && snake2.direction.move != {0, 1}:
			snake2.direction.move = {0, -1}
			snake2.direction.change_thick = true

		case rl.IsKeyPressed(.S) && snake2.direction.move != {0, -1}:
			snake2.direction.move = {0, 1}
			snake2.direction.change_thick = true

		case rl.IsKeyPressed(.D) && snake2.direction.move != {-1, 0}:
			snake2.direction.move = {1, 0}
			snake2.direction.change_thick = true

		case rl.IsKeyPressed(.A) && snake2.direction.move != {1, 0}:
			snake2.direction.move = {-1, 0}
			snake2.direction.change_thick = true
		}
	}


	if snake1.game_over && snake2.game_over {

		if rl.IsKeyPressed(.ENTER) {
			restart_snake(snake1, {0, 1}, -2)
			restart_snake(snake2, {0, -1}, 2)
		}

	} else {
		snake1.direction.tick_timer -= rl.GetFrameTime()
		snake2.direction.tick_timer -= rl.GetFrameTime()
	}

	// if snake1.direction.tick_timer <= 0 {
	// 	next_part_pos := snake1.body[0]
	// 	snake1.body[0] += snake1.direction.move
	// 	snake1.direction.change_thick = false
	// 	head_pos := snake1.body[0]
	//
	// 	if head_pos.x < 0 ||
	// 	   head_pos.y < 0 ||
	// 	   head_pos.x >= GRID_WIDTH ||
	// 	   head_pos.y >= GRID_WIDTH {
	// 		// snake1.length -= 1
	// 		rl.PlaySound(sound_shrink)
	// 		// restart_snake(snake1, head_pos, calculate_direction(snake1^), MIN_SNAKE_LENGTH)
	// 		// restart_snake(snake1, {GRID_WIDTH - 2, 0}, {0, 1}, MIN_SNAKE_LENGTH)
	// 		restart_snake(snake1, {10, 2}, {0, 1}, snake1.length)
	//
	// 	}
	//
	// 	for i in 1 ..< snake1.length {
	// 		cur_pos := snake1.body[i]
	//
	// 		if cur_pos == head_pos {
	// 			snake1.game_over = true
	// 			rl.PlaySound(sound_crash)
	// 		}
	//
	// 		snake1.body[i] = next_part_pos
	// 		next_part_pos = cur_pos
	// 	}
	//
	// 	if head_pos == snake1.food {
	// 		snake1.length += 1
	// 		snake1.body[snake1.length - 1] = next_part_pos
	// 		random_food(snake1)
	// 		rl.PlaySound(sound_eat)
	// 	}
	//
	// 	if head_pos == snake2.food {
	// 		snake1.length -= 1
	// 		random_food(snake2)
	// 		rl.PlaySound(sound_shrink)
	// 	}
	//
	// 	snake1.direction.tick_timer = TICK_RATE + snake1.direction.tick_timer
	// }
	//
	// if snake2.direction.tick_timer <= 0 {
	// 	next_part_pos := snake2.body[0]
	// 	snake2.body[0] += snake2.direction.move
	// 	snake2.direction.change_thick = false
	// 	head_pos := snake2.body[0]
	//
	// 	if head_pos.x < 0 ||
	// 	   head_pos.y < 0 ||
	// 	   head_pos.x >= GRID_WIDTH ||
	// 	   head_pos.y >= GRID_WIDTH {
	// 		// snake2.length -= 1
	// 		rl.PlaySound(sound_shrink)
	// 		// restart_snake(snake2, head_pos, calculate_direction(snake2^), MIN_SNAKE_LENGTH)
	// 		// restart_snake(snake2, {0, GRID_WIDTH - 2}, {0, -1}, MIN_SNAKE_LENGTH)
	// 		restart_snake(snake2, {18, 2}, {0, 1}, snake2.length)
	// 	}
	//
	// 	for i in 1 ..< snake2.length {
	// 		cur_pos := snake2.body[i]
	//
	// 		if cur_pos == head_pos {
	// 			snake2.game_over = true
	// 			rl.PlaySound(sound_crash)
	// 		}
	//
	// 		snake2.body[i] = next_part_pos
	// 		next_part_pos = cur_pos
	// 	}
	//
	// 	if head_pos == snake2.food {
	// 		snake2.length += 1
	// 		snake2.body[snake2.length - 1] = next_part_pos
	// 		random_food(snake2)
	// 		rl.PlaySound(sound_grow)
	// 	}
	//
	// 	if head_pos == snake1.food {
	// 		snake2.length -= 1
	// 		random_food(snake1)
	// 		rl.PlaySound(sound_shrink)
	// 	}
	//
	// 	snake2.direction.tick_timer = TICK_RATE + snake2.direction.tick_timer
	// }
	//

	if snake1.direction.tick_timer <= 0 {
		next_part_pos := snake1.body[0]
		snake1.body[0] += snake1.direction.move

		// snake1.body[0].x = wrap_coord(snake1.body[0].x)
		// snake1.body[0].y = wrap_coord(snake1.body[0].y)
		snake1.body[0] = wrap_vec2i(snake1.body[0], &snake1.length)

		snake1.direction.change_thick = false
		head_pos := snake1.body[0]

		for i in 1 ..< snake1.length {
			cur_pos := snake1.body[i]

			if cur_pos == head_pos {
				// snake1.game_over = true
				snake1.length -= 1
				rl.PlaySound(sound_shrink)
			}

			snake1.body[i] = next_part_pos
			next_part_pos = cur_pos
		}

		if head_pos == snake1.food {
			snake1.length += 1
			snake1.body[snake1.length - 1] = next_part_pos
			random_food(snake1)
			rl.PlaySound(sound_eat)
		}

		if head_pos == snake2.food {
			snake1.length -= 1
			random_food(snake2)
			rl.PlaySound(sound_shrink)
		}

		snake1.direction.tick_timer = TICK_RATE + snake1.direction.tick_timer
	}

	if snake2.direction.tick_timer <= 0 {
		next_part_pos := snake2.body[0]
		snake2.body[0] += snake2.direction.move

		// snake2.body[0].x = wrap_coord(snake2.body[0].x)
		// snake2.body[0].y = wrap_coord(snake2.body[0].y)

		snake2.body[0] = wrap_vec2i(snake2.body[0], &snake2.length)

		snake2.direction.change_thick = false
		head_pos := snake2.body[0]

		for i in 1 ..< snake2.length {
			cur_pos := snake2.body[i]

			if cur_pos == head_pos {
				// snake2.game_over = true
				snake2.length -= 1
				rl.PlaySound(sound_shrink)
			}

			snake2.body[i] = next_part_pos
			next_part_pos = cur_pos
		}

		if head_pos == snake2.food {
			snake2.length += 1
			snake2.body[snake2.length - 1] = next_part_pos
			random_food(snake2)
			rl.PlaySound(sound_grow)
		}

		if head_pos == snake1.food {
			snake2.length -= 1
			random_food(snake1)
			rl.PlaySound(sound_shrink)
		}

		snake2.direction.tick_timer = TICK_RATE + snake2.direction.tick_timer
	}

}
