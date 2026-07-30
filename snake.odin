package snake

import rl "vendor:raylib"

single_snake_movement :: proc(snake: ^Snake, assets: Assets) {
	if snake.game_over {
		if rl.IsKeyPressed(.ENTER) {
			restart_snake(snake, {0, 1})
		}
		return
	}

	snake.direction.tick_timer -= rl.GetFrameTime()

	results := calculate_move(snake^, assets)

	head_pos := results.snake.body[0]

	// Wall collision
	if head_pos.x < 0 || head_pos.y < 0 || head_pos.x >= GRID_WIDTH || head_pos.y >= GRID_WIDTH {

		results.snake.game_over = true
		rl.PlaySound(assets.crash)
	}

	// Self collision
	for i in 1 ..< results.snake.length {
		if results.snake.body[i] == head_pos {
			results.snake.game_over = true
			rl.PlaySound(assets.crash)
			break
		}
	}

	// Food
	if head_pos == results.snake.food {
		results.snake.length += 1

		results.snake.body[results.snake.length - 1] = results.tail_pos

		random_food(&results.snake)
		rl.PlaySound(assets.eat)
	}

	// Commit 	
	snake^ = results.snake
}

double_snake_movement :: proc(
	snake_player1: ^Snake,
	snake_player2: ^Snake,
	assets: Assets,
	teleportation := true,
) {
	if snake_player1.game_over || snake_player2.game_over {
		if rl.IsKeyPressed(.ENTER) {
			restart_snake(snake_player1, {0, 1}, DEFAULT_MANIPULATOR_POS)
			restart_snake(snake_player2, {0, 1}, DEFAULT_MANIPULATOR_NEG)
		}
		return
	}

	snake_player1.direction.tick_timer -= rl.GetFrameTime()
	snake_player2.direction.tick_timer -= rl.GetFrameTime()

	result_player_1 := calculate_move(snake_player1^, assets, true, .Arrows)
	result_player_2 := calculate_move(snake_player2^, assets, true, .Letters)

	if !(result_player_1.moved || result_player_2.moved) {
		snake_player1^ = result_player_1.snake
		snake_player2^ = result_player_2.snake
		return
	}

	head_pos_player_1 := result_player_1.snake.body[0]
	head_pos_player_2 := result_player_2.snake.body[0]

	// Damage tracker
	hit_player_1 := false
	hit_player_2 := false

	// Teleportation
	if teleportation {
		if result_player_1.wrapped {
			hit_player_1 = true
		}
		if result_player_2.wrapped {
			hit_player_2 = true
		}
	}

	player_1_length := result_player_1.snake.length
	player_2_length := result_player_2.snake.length

	// Self Collision and enemy damage
	for i in 1 ..< result_player_1.snake.length {
		cur_pos := result_player_1.snake.body[i]

		if cur_pos == head_pos_player_1 {
			hit_player_1 = true
		}

		if cur_pos == head_pos_player_2 {
			hit_player_2 = true
		}
	}

	for i in 1 ..< result_player_2.snake.length {
		cur_pos := result_player_2.snake.body[i]

		if cur_pos == head_pos_player_2 {
			hit_player_2 = true
		}

		if cur_pos == head_pos_player_1 {
			hit_player_1 = true
		}
	}

	// Head to head collision
	if head_pos_player_1 == head_pos_player_2 {
		switch {
		case player_1_length > player_2_length:
			hit_player_2 = true

		case player_1_length < player_2_length:
			hit_player_1 = true

		case player_1_length == player_2_length:
			hit_player_1 = true
			hit_player_2 = true
		}

	}

	// Bad Food
	if head_pos_player_1 == result_player_2.snake.food {
		hit_player_1 = true
		random_food(&result_player_2.snake)
		rl.PlaySound(assets.shrink)
	}

	if head_pos_player_2 == result_player_1.snake.food {
		hit_player_2 = true
		random_food(&result_player_1.snake)
		rl.PlaySound(assets.shrink)
	}

	// Apply damage
	if hit_player_1 {
		result_player_1.snake.length -= 1
		rl.PlaySound(assets.shrink)
	}

	if hit_player_2 {
		result_player_2.snake.length -= 1
		rl.PlaySound(assets.shrink)
	}

	// Good Food
	if head_pos_player_1 == result_player_1.snake.food {
		result_player_1.snake.length += 1

		result_player_1.snake.body[result_player_1.snake.length - 1] = result_player_1.tail_pos

		random_food(&result_player_1.snake)
		rl.PlaySound(assets.eat)
	}

	if head_pos_player_2 == result_player_2.snake.food {
		result_player_2.snake.length += 1

		result_player_2.snake.body[result_player_2.snake.length - 1] = result_player_2.tail_pos

		random_food(&result_player_2.snake)
		rl.PlaySound(assets.grow)
	}

	// Game over
	if result_player_1.snake.length < MIN_SNAKE_LENGTH {
		result_player_1.snake.game_over = true
		rl.PlaySound(assets.crash)
	}
	if result_player_2.snake.length < MIN_SNAKE_LENGTH {
		result_player_2.snake.game_over = true
		rl.PlaySound(assets.crash)
	}

	// Commit
	snake_player1^ = result_player_1.snake
	snake_player2^ = result_player_2.snake
}
