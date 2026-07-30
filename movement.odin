package snake

import rl "vendor:raylib"

teleport_snake :: proc(v: Vec2i) -> (coord: Vec2i, wrapped: bool) {
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
	coord = Vec2i{x, y}

	if wrap_x || wrap_y {
		wrapped = true
	}

	return
}

restart_snake :: proc(
	snake: ^Snake,
	dirction: Vec2i,
	location_manipulator_x := 0,
	snake_length := MIN_SNAKE_LENGTH,
) {
	start_head_pos := Vec2i{(GRID_WIDTH + location_manipulator_x) / 2, GRID_WIDTH / 2}
	snake.body[0] = start_head_pos
	snake.body[1] = start_head_pos - {0, 1}
	snake.body[2] = start_head_pos - {0, 2}
	snake.length = snake_length
	snake.game_over = false
	random_food(snake)
	snake.direction.move = dirction
	snake.score.current = 0
}


calculate_move :: proc(
	snake: Snake,
	assets: Assets,
	teleportation := false,
	layout := Layout.Arrows,
) -> MoveResult {
	snake := snake
	keys: KeyStructure

	// For the teleport_snake() bool
	wrapped: bool

	// For the return struct
	tail_pos: Vec2i

	switch layout {
	case .Arrows:
		keys = KeyStructure {
			up    = rl.IsKeyPressed(.UP),
			down  = rl.IsKeyDown(.DOWN),
			right = rl.IsKeyDown(.RIGHT),
			left  = rl.IsKeyDown(.LEFT),
		}
	case .Letters:
		keys = KeyStructure {
			up    = rl.IsKeyPressed(.W),
			down  = rl.IsKeyDown(.S),
			right = rl.IsKeyDown(.D),
			left  = rl.IsKeyDown(.A),
		}
	}

	if !snake.direction.change_thick {
		switch {
		case keys.up && snake.direction.move != {0, 1}:
			snake.direction.move = {0, -1}
			snake.direction.change_thick = true

		case keys.down && snake.direction.move != {0, -1}:
			snake.direction.move = {0, 1}
			snake.direction.change_thick = true

		case keys.right && snake.direction.move != {-1, 0}:
			snake.direction.move = {1, 0}
			snake.direction.change_thick = true

		case keys.left && snake.direction.move != {1, 0}:
			snake.direction.move = {-1, 0}
			snake.direction.change_thick = true
		}
	}

	moved := false

	if snake.direction.tick_timer <= 0 {
		moved = true

		next_part_pos := snake.body[0]
		snake.body[0] += snake.direction.move

		if teleportation {
			snake.body[0], wrapped = teleport_snake(snake.body[0])
		}

		snake.direction.change_thick = false
		head_pos := snake.body[0]

		for i in 1 ..< snake.length {
			cur_pos := snake.body[i]
			snake.body[i] = next_part_pos
			next_part_pos = cur_pos
		}
		tail_pos = next_part_pos

		snake.direction.tick_timer = TICK_RATE + snake.direction.tick_timer
	}

	results := MoveResult {
		snake    = snake,
		wrapped  = wrapped,
		tail_pos = tail_pos,
		moved    = moved,
	}

	return results
}
